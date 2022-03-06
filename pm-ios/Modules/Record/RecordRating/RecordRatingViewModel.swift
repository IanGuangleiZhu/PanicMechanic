//
//  RecordRatingViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat

fileprivate let STEP_SECONDS = 20
fileprivate let TIMER_MS_INCREMENT = 100

class RecordRatingViewModel: RecordRatingViewModelType {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: RecordRatingViewModelCoordinatorDelegate?
    weak var viewDelegate: RecordRatingViewModelViewDelegate?
    
    // MARK: - Dependencies
    var localCache: LocalCache
    let questionType: RatingQuestionType
    let cycleService: CycleService?
    let isTutorial: Bool
    
    // MARK: - Properties
    var timer: Repeater?
    
    // MARK: - Lifecycle
    init(localCache: LocalCache, questionType: RatingQuestionType, cycleService: CycleService?, isTutorial: Bool) {
        self.localCache = localCache
        self.cycleService = cycleService
        self.questionType = questionType
        self.isTutorial = isTutorial
    }
    
}

// MARK: - Model Type
extension RecordRatingViewModel {
    
    func start() {
        log.info("Presenting question", context: questionType)
        let barTitle = questionType == .anxiety ? "Anxiety" : "Quality"
        let title = Questions.instructionsFor(questionType: questionType)
        let instructions = String(format: Questions.titleFor(questionType: questionType), title)
        let options = Questions.optionsFor(questionType: questionType)
        DispatchQueue.main.async {
            self.viewDelegate?.updateTitle(title: barTitle)
            self.viewDelegate?.updateQuestion(title: title, instructions: instructions, options: options)
        }
        if !isTutorial {
            startTimer()
        } else {
            // If something went wrong, force cached value to keep tutorial on track
            if localCache.tutorialHeartRate == 0 {
                localCache.tutorialHeartRate = 50
            }
        }
    }
    
    func getQuestionType() -> RatingQuestionType {
        return questionType
    }
    
    func mapValueToOption(value: Int) -> String {
        let options =  Questions.optionsFor(questionType: questionType)
        return options[value - 1]
    }
    
    func proceed(with rating: Int) {
        if !isTutorial {
            stopTimer()
            save(rating: rating)
        } else {
            localCache.tutorialAnxiety = rating
        }
        if questionType == .anxiety {
            coordinatorDelegate?.proceedFromAnxietyQuestion()
        } else {
            coordinatorDelegate?.proceedFromQualityQuestion()
        }
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

// MARK: - Timeable
extension RecordRatingViewModel: Timeable {
    
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
                    self.proceed(with: 0)
                }
            default:
                //                    print("Current State: \(state)")
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
extension RecordRatingViewModel {
    
    private func save(rating: Int) {
        switch questionType {
        case .anxiety:
            cycleService?.loadLatestCycle { cycle, error in
                if let error = error {
                    log.error("Error occured while fetching latest cycle:", context: error)
                    return
                }
                log.info("Loaded latest cycle:", context: cycle)
                if let cycle = cycle {
                    self.cycleService?.add(rating: rating, to: cycle)
                }
            }
        default:
            cycleService?.loadLatestCycle { cycle, error in
                if let error = error {
                    log.error("Error occured while fetching latest cycle:", context: error)
                    return
                }
                log.info("Loaded latest cycle:", context: cycle)
                if let cycle = cycle {
                    self.cycleService?.add(rating: rating, questionType: self.questionType, to: cycle)
                }
            }
        }
    }
    
}
