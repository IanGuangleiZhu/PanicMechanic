//
//  CycleService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol CycleService {
    func loadLatestCycle(handler: @escaping (Cycle?, Error?) -> Void)
    func loadCycles(handler: @escaping ([Cycle]?, Error?) -> Void)
    func loadCycles(after: Date, handler: @escaping ([Cycle]?, Error?) -> Void)
    func loadCycles(from: Date, to: Date, handler: @escaping ([Cycle]?, Error?) -> Void)
    func create(bpm: Int)
    func add(rating: Int, to cycle: Cycle)
    func add(rating: Int, questionType: RatingQuestionType, to cycle: Cycle)
    func add(trigger: String?, to cycle: Cycle)
    func complete(cycle: Cycle)
    func deleteCycles(handler: @escaping (Error?) -> Void)
}

class CycleAPIService {
    
    let localStore: LocalStore
    
    init(localStore: LocalStore) {
        self.localStore = localStore
    }
    
}

// MARK: - API
extension CycleAPIService: CycleService {
    
    // Fetching
    func loadLatestCycle(handler: @escaping (Cycle?, Error?) -> Void) {
        localStore.fetchCycle(context: localStore.backgroundContext, handler: handler)
    }
    
    func loadCycles(handler: @escaping ([Cycle]?, Error?) -> Void) {
        localStore.fetchCycles(context: localStore.backgroundContext, handler: handler)
    }
    
    func loadCycles(after: Date, handler: @escaping ([Cycle]?, Error?) -> Void) {
        localStore.fetchCycles(context: localStore.backgroundContext, start: after, stop: nil, handler: handler)
    }
    
    func loadCycles(from: Date, to: Date, handler: @escaping ([Cycle]?, Error?) -> Void) {
        // Fetch cached Cycles
        localStore.fetchCycles(context: localStore.backgroundContext, start: from, stop: to, handler: handler)
    }
    
    // Saving
    func create(bpm: Int) {
        let now = Date()
        let cycle = Cycle(context: localStore.backgroundContext)
        if bpm > 0 {
            let hrSample = HeartRateSample(context: localStore.backgroundContext)
            hrSample.bpm = Int16(bpm)
            hrSample.ts = now
            cycle.hr = hrSample
        }
        cycle.lastUpdated = now
        cycle.endTs = nil
        
        localStore.save(with: localStore.backgroundContext)
    }
    
    func add(rating: Int, to cycle: Cycle) {
        let now = Date()
        if rating > 0 {
            let anxietyRating = AnxietyRating(context: localStore.backgroundContext)
            anxietyRating.score = Int16(rating)
            anxietyRating.ts = now
            cycle.anxiety = anxietyRating
        }
        cycle.lastUpdated = now

        localStore.save(with: localStore.backgroundContext)
    }
    
    func add(rating: Int, questionType: RatingQuestionType, to cycle: Cycle) {
        let now = Date()
        if rating > 0 {
            let qualityScore = QualityQuestion(context: localStore.backgroundContext)
            qualityScore.type = questionType.rawValue.uppercased()
            qualityScore.score = Int16(rating)
            qualityScore.ts = now
            cycle.quality = qualityScore
        }

        cycle.lastUpdated = now

        localStore.save(with: localStore.backgroundContext)
    }
    
    func add(trigger: String?, to cycle: Cycle) {
        let now = Date()
        if let trigger = trigger {
            let triggerQuestion = TriggerQuestion(context: localStore.backgroundContext)
            triggerQuestion.trigger = trigger
            triggerQuestion.ts = Date()
            cycle.trigger = triggerQuestion
        }
        cycle.lastUpdated = now
        cycle.endTs = now

        localStore.save(with: localStore.backgroundContext)
    }
    
    func complete(cycle: Cycle) {
        let now = Date()
        cycle.lastUpdated = now
        cycle.endTs = now
        localStore.save(with: localStore.backgroundContext)
    }
    
    // Delete
    func deleteCycles(handler: @escaping (Error?) -> Void) {
        localStore.deleteCycles(context: localStore.backgroundContext, handler: handler)
    }
    
}
