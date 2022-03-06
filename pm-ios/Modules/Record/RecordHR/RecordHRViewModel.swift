//
//  RecordHRViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat

fileprivate let MIN_SAMPLES: Int = 240
fileprivate let STEP_SECONDS = 30
fileprivate let TIMER_MS_INCREMENT = 100

class RecordHRViewModel: NSObject {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: RecordHRViewModelCoordinatorDelegate?
    weak var viewDelegate: RecordHRViewModelViewDelegate?
    
    // MARK: - Dependencies
    private var cameraClient: CameraClient
    private var localCache: LocalCache
    private let fingerDetectService: FingerDetectService
    private let heartRateService: HeartRateService
    private let episodeService: EpisodeService
    private let cycleService: CycleService?
    private let episodeLocationService: EpisodeLocationService?
    private let isTutorial: Bool
    
    // MARK: - Properties
    var timer: Repeater?
    private var samples: [Double] = []
    private let detectionQueue: DispatchQueue = DispatchQueue(label: "finger-service-detection-queue")
    private var numCycles: Int = 0
    
    // MARK: - Lifecycle
    init(cameraClient: CameraClient, localCache: LocalCache, fingerDetectService: FingerDetectService, heartRateService: HeartRateService, episodeService: EpisodeService, cycleService: CycleService?, episodeLocationService: EpisodeLocationService?, isTutorial: Bool) {
        self.cameraClient = cameraClient
        self.localCache = localCache
        self.fingerDetectService = fingerDetectService
        self.heartRateService = heartRateService
        self.episodeService = episodeService
        self.cycleService = cycleService
        self.episodeLocationService = episodeLocationService
        self.isTutorial = isTutorial
    }
    
}

// MARK: - Model Type
extension RecordHRViewModel: RecordHRViewModelType {
    
    var practiceModeEnabled: Bool {
        return localCache.practiceModeEnabled
    }
    
    var shouldShowCancelButton: Bool {
        return !isTutorial
    }
    
    var shouldShowFinishButton: Bool {
        return (!isTutorial && localCache.currentCycleCount > 0) || (isTutorial && localCache.tutorialHeartRate > 0 && localCache.tutorialAnxiety > 0)
    }
    
    var shouldShowCompleteCoachMarks: Bool {
        return isTutorial && localCache.tutorialHeartRate > 0 && localCache.tutorialAnxiety > 0
    }
    
    func start() {
        // Fetch cached cycles
        if !isTutorial { loadCurrentCycles() }

        // Clear samples array
        samples.removeAll()
            
        // Tell the camera client what to do with each frame
        cameraClient.frameHandler = { frame in
            let redness = self.fingerDetectService.detect(pixelBuffer: frame)
            DispatchQueue.main.async {
                if !self.cameraClient.torchEnabled {
                    DefaultVideoClient.toggleTorch(on: true)
                }
                if let redness = redness {
                    self.handleFingerDetected(redness: redness)
                } else {
                    self.handleFingerUndetected()
                }
            }
        }
        
        // Start the timer and camera if we are in a live recording
        if !isTutorial {
            enableCamera()
            startTimer()
        }
    }
    
    func teardown() {
        stopTimer()
        disableCamera()
    }
    
    func proceed() {
        log.info("Proceeding...")
        
        if isTutorial { teardown() }
        
        // Navigate to next step
        coordinatorDelegate?.proceedFromHRRecorder()
    }
    
    func finishAttack() {
        if isTutorial {
            coordinatorDelegate?.proceedFromHRRecorder()
        } else {
            log.info("Finishing attack")
            // Disable camera and timer
            teardown()
            
            localCache.attackStopTimestamp = Date()
                    
            // Upload data to backend in live mode
            if !practiceModeEnabled {
                upload()
            }
            
            // Navigate back home
            coordinatorDelegate?.dismiss()
        }
    }
    
    func cancelAttack() {
        log.info("Cancelling attack")

        // Disable camera and timer
        teardown()
        
        // Navigate back home
        coordinatorDelegate?.dismiss()
    }
    
    func startTutorial() {
        if isTutorial {
            viewDelegate?.showCoachMarks()
        }
    }
    
    func stopTutorial() {
        if isTutorial {
            viewDelegate?.hideCoachMarks()
        }
    }
    
    func enableCamera() {
        if !cameraClient.isRunning {
            cameraClient.start {
                log.info("Started camera")
                self.viewDelegate?.setPreviewSession(session: self.cameraClient.session)
                DefaultVideoClient.toggleTorch(on: true)
            }
        } else {
            log.info("Camera is already running")
        }
    }
    
    func disableCamera() {
        if cameraClient.isRunning {
            cameraClient.stop() {
                log.info("Stopped camera")
                self.viewDelegate?.setPreviewSession(session: nil)
                DefaultVideoClient.toggleTorch(on: false)
            }
        } else {
            log.info("Camera isn't running")
        }
    }
    
}

// MARK: - Timeable
extension RecordHRViewModel: Timeable {
    
    func startTimer() {
        log.warning("Starting timer", context: timer)
        // Need to divide into 1000 to convert seconds
        let count = (1000/TIMER_MS_INCREMENT) * STEP_SECONDS
        self.timer = Repeater.every(.milliseconds(TIMER_MS_INCREMENT), count: count) { timer in
            if let remainingIterations = timer.remainingIterations {
                log.verbose("Remaining iterations", context: remainingIterations)
                let progress = Float(count - remainingIterations)/Float(count)
                self.viewDelegate?.updateProgressBar(progress: progress)
            }
        }
        self.timer?.onStateChanged = { timer, state in
            switch state {
            case .finished:
                log.verbose("Timer finished")
                self.teardown()
                self.processSamples()
                DispatchQueue.main.async {
                    self.proceed()
                }
            default:
                return
            }
        }
    }
    
    func stopTimer() {
        log.warning("Stopping timer", context: timer)
        timer?.pause()
        timer = nil
    }
    
}

// MARK: - Private Helpers -
extension RecordHRViewModel {
    
    private func loadCurrentCycles() {
        if let attackStartTimestamp = self.localCache.attackStartTimestamp {
            // Fetch cached Cycles
            cycleService?.loadCycles(after: attackStartTimestamp) { cycles, error in
                if let error = error {
                    log.error("Error getting cached cycles after:", context: [attackStartTimestamp, error])
                    return
                } else {
                    if let cycles = cycles {
                        let dataset: [(Int, Int)] = cycles.enumerated().map { ($0.0, Int($0.1.hr?.bpm ?? 0)) }
                        DispatchQueue.main.async {
                            self.viewDelegate?.updateHeartRatePlot(data: dataset)
                        }
                    } else {
                        log.error("Error reading cached cycle data.")
                    }
                }
            }
        }
    }
    
    private func processSamples() {
        log.verbose("Processing samples")
        if let hr = heartRateService.calculate(samples: &samples) {
            if !self.isTutorial {
                cycleService?.create(bpm: Int(hr))
            } else {
                // Just cache the HR value for the tutorial
                let tutorialHR = Int(hr)
                localCache.tutorialHeartRate = tutorialHR
                log.info("Recevied tutorial HR:", context: hr)
                viewDelegate?.updateHeartRatePlot(data: [(0, tutorialHR)])
                viewDelegate?.showNextCoachMark()
            }
        } else {
            log.warning("Could not calculate heart rate")
            if !isTutorial {
                cycleService?.create(bpm: 0)
            } else {
                // Hardcode a value to get user through onboarding if it fails
                let tutorialHR = 50
                localCache.tutorialHeartRate = tutorialHR
                viewDelegate?.updateHeartRatePlot(data: [(0, tutorialHR)])
                viewDelegate?.showNextCoachMark()
            }
        }
    }
    
    private func handleFingerDetected(redness: Double) {
        log.verbose("Handling detected finger")
        if self.samples.count == MIN_SAMPLES {
            log.verbose("Minimum samples received")
            if !self.isTutorial {
                self.teardown()
                self.processSamples()
                DispatchQueue.main.async {
                    self.proceed()
                }
            } else {
                // Running tutorial
                self.disableCamera()
                self.processSamples()
            }
        } else {
            self.samples.append(redness)
        }
        let percent = Int(Float(self.samples.count)/Float(MIN_SAMPLES) * 100)
        self.viewDelegate?.updateDetectionElements(percent: percent, detected: true)
    }
    
    private func handleFingerUndetected() {
        log.verbose("Handling undetected finger")
        if self.samples.count > 0 { self.samples.removeAll() }
        self.viewDelegate?.updateDetectionElements(percent: 0, detected: false)
    }
    
    private func upload() {
        guard let uid = episodeService.generateEpisodeId(), let start = localCache.attackStartTimestamp, let stop = localCache.attackStopTimestamp else { return }
        cycleService?.loadCycles(from: start, to: stop) { cycles, error in
            if let error = error {
                log.error("Error occured while fetching cycles:", context: error)
                return
            }
            if let cycles = cycles {
                var pmcycles: [PanicMechanicCycle] = []
                for cycle in cycles {
                    if let endTs = cycle.endTs {
                        var hrSample: PanicMechanicHRSample?
                        var anxietySample: PanicMechanicAnxietySample?
                        var question: PanicMechanicQuestion?
                        
                        if let hr = cycle.hr, let hrTs = hr.ts, hr.bpm > 0 {
                            hrSample = PanicMechanicHRSample(bpm: Int(hr.bpm), ts: hrTs)
                        }
                        if let anxiety = cycle.anxiety, let anxietyTs = anxiety.ts, anxiety.score > 0 {
                            anxietySample = PanicMechanicAnxietySample(rating: Int(anxiety.score), ts: anxietyTs)
                        }
                        if let qualityQuestion = cycle.quality, let qname = qualityQuestion.type, qualityQuestion.score > 0 {
                            let answer = String(qualityQuestion.score)
                            question = PanicMechanicQuestion(name: qname, answer: answer)
                        }
                        if let triggerQuestion = cycle.trigger, let trigger = triggerQuestion.trigger {
                            question = PanicMechanicQuestion(name: "TRIGGER", answer: trigger)
                        }
                        let c = PanicMechanicCycle(hr: hrSample, anxiety: anxietySample, question: question, endTs: endTs)
                        pmcycles.append(c)
                    }
                }
                for cycle in pmcycles {
                    log.info("PMC:", context: cycle)
                }
                var episode = PanicMechanicEpisode(uid: uid, startTs: start, stopTs: stop, updatedAt: stop, location: nil, cycles: pmcycles)
                self.episodeLocationService?.loadLatestEpisodeLocation { location, error in
                    if let error = error {
                        log.error("Error occurred fetching locations:", context: error)
                    }
                    if let location = location, let name = location.name {
                        let pmlocation = PanicMechanicLocation(name: name, latitude: location.latitude, longitude: location.longitude)
                        episode.location = pmlocation
                    }
                    self.episodeService.addEpisode(episode: episode) { error in
                        if let error = error {
                            log.error("Error occurred while adding episode:", context: error)
                            return
                        }
                        log.info("Successfully uploaded episode.")
                    }
                }
            }
            
        }
    }
    
}
