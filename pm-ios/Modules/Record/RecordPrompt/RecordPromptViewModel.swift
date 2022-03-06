//
//  RecordPromptViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat

fileprivate let STEP_SECONDS = 10
fileprivate let TIMER_MS_INCREMENT = 100

class RecordPromptViewModel: RecordPromptViewModelType {
    
    weak var coordinatorDelegate: RecordPromptViewModelCoordinatorDelegate?
    weak var viewDelegate: RecordPromptViewModelViewDelegate?
    
    var localCache: LocalCache
    let cycleService: CycleService?
    let isTutorial: Bool
    var user: PanicMechanicUser?
    var timer: Repeater?
    
    init(localCache: LocalCache, cycleService: CycleService?, isTutorial: Bool, user: PanicMechanicUser?) {
        self.localCache = localCache
        self.cycleService = cycleService
        self.isTutorial = isTutorial
        self.user = user
    }
    
    func start() {
        if let user = user, let start = localCache.attackStartTimestamp {
            let elapsed = Date() - start
            let remaining = (user.stats.recoveryDuration/60000) - elapsed
            let duration = remaining > 0 ? remaining : 0 // Converting to minutes from millseconds
            log.info("START: \(start) ELAPSED: \(elapsed) RD: \(user.stats.recoveryDuration), REMAIN: \(remaining) DUR: \(duration)")
            viewDelegate?.updateRecoveryLabel(duration: duration)
        } else {
            // Hardcoded value for tutorial
            viewDelegate?.updateRecoveryLabel(duration: 2)
        }
        if !isTutorial {
            startTimer()
        }
    }
    
    func save() {
        cycleService?.loadLatestCycle { cycle, error in
            if let error = error {
                log.error("Error occured while fetching latest cycle:", context: error)
                return
            }
            log.info("Loaded latest cycle:", context: cycle)
            if let cycle = cycle {
                self.cycleService?.complete(cycle: cycle)
            }
        }
    }
    
    func proceed() {
        if !isTutorial {
            stopTimer()
            localCache.currentCycleCount += 1
            save()
        }
        coordinatorDelegate?.proceedFromPrompt()
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
    
}

// MARK: - Timeable -
extension RecordPromptViewModel: Timeable {
    
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
