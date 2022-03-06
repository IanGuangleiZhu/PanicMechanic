//
//  RecordQuestionViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat


fileprivate let STEP_SECONDS = 20
fileprivate let TIMER_MS_INCREMENT = 100
fileprivate let DEFAULT_ITEMS = [
    "Caffeine or Other Substance",
    "Conflict",
    "Finances",
    "Health",
    "Performance",
    "Physical Surroundings",
    "Social Situation",
    "Workload"
]

class RecordQuestionViewModel {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: RecordQuestionViewModelCoordinatorDelegate?
    weak var viewDelegate: RecordQuestionViewModelViewDelegate?
    
    // MARK: - Dependencies -
    var localCache: LocalCache
    let cycleService: CycleService?
    let isTutorial: Bool
    private let user: PanicMechanicUser?
    
    // MARK: - Properties -
    var timer: Repeater?
    private var customTriggers: [String] = [] {
        didSet {
            viewDelegate?.reloadData()
        }
    }
    private var trigger: String? = nil
    
    init(localCache: LocalCache, cycleService: CycleService?, isTutorial: Bool, user: PanicMechanicUser?) {
        self.localCache = localCache
        self.cycleService = cycleService
        self.isTutorial = isTutorial
        self.user = user
    }
    
    func start() {
        if !isTutorial {
            startTimer()
        }
        if let user = user {
            self.customTriggers = user.triggers
        }
    }
    
    private func save() {
        cycleService?.loadLatestCycle { cycle, error in
            if let error = error {
                log.error("Error occured while fetching latest cycle:", context: error)
                return
            }
            log.info("Loaded latest cycle:", context: cycle)
            if let cycle = cycle {
                self.cycleService?.add(trigger: self.trigger, to: cycle)
            }
        }
    }
    
}

// MARK: - Timeable -
extension RecordQuestionViewModel: Timeable {
    
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

// MARK: - Model Type -
extension RecordQuestionViewModel: RecordQuestionViewModelType {
    
    func proceed() {
        if !isTutorial {
            stopTimer()
            localCache.currentCycleCount += 1
            save()
        }
        coordinatorDelegate?.proceedFromTriggerQuestion()
    }
    
    func pause() {
        if !isTutorial {
            timer?.pause()
        } else {
            print("No timer during tutorial")
        }
    }
    
    func resume() {
        if !isTutorial {
            timer?.start()
        } else {
            print("No timer during tutorial")
        }
    }
    
    func addTrigger() {
        viewDelegate?.showAddCustomTriggerAlert()
    }
    
    func handle(trigger: String) {
        customTriggers.append(trigger)
        viewDelegate?.reloadData()
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
    
    func numberSections() -> Int {
        if customTriggers.count > 0 {
            return 2
        }
        return 1
    }
    
    func numberRows(in section: Int) -> Int {
        if customTriggers.count > 0 {
            if section == 0 {
                return customTriggers.count
            }
        }
        return DEFAULT_ITEMS.count
    }
    
    func item(at indexPath: IndexPath) -> String? {
        if customTriggers.count > 0 {
            switch indexPath.section {
            case 0:
                return customTriggers[indexPath.row]
            case 1:
                return DEFAULT_ITEMS[indexPath.row]
            default:
                return nil
            }
        }
        return DEFAULT_ITEMS[indexPath.row]
    }
    
    func didSelect(at indexPath: IndexPath) {
        if customTriggers.count > 0 {
            if indexPath.section == 0 {
                trigger = customTriggers[indexPath.row]
            } else {
                trigger = DEFAULT_ITEMS[indexPath.row]
            }
        } else {
            trigger = DEFAULT_ITEMS[indexPath.row]
        }
    }
    
}
