//
//  TutorialWelcomeViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TutorialWelcomeViewModelType {
    
    var viewDelegate: TutorialWelcomeViewModelViewDelegate? { get set }
    var coordinatorDelegate: TutorialWelcomeViewModelCoordinatorDelegate? { get set }

    func start()
    
    func proceed()
    
}

protocol TutorialWelcomeViewModelCoordinatorDelegate: class {
        
    func proceedFromWelcome()
}

protocol TutorialWelcomeViewModelViewDelegate: class {

    
}

class TutorialWelcomeViewModel: TutorialWelcomeViewModelType {
    
    weak var coordinatorDelegate: TutorialWelcomeViewModelCoordinatorDelegate?
    weak var viewDelegate: TutorialWelcomeViewModelViewDelegate?
    
    var localCache: LocalCache
    let isAbridged: Bool
    
    init(localCache: LocalCache, isAbridged: Bool) {
        self.localCache = localCache
        self.isAbridged = isAbridged
    }
    
    func start() {
        clearCache()
    }
    
    private func clearCache() {
        print("Clearing tutorial cache")
        localCache.tutorialHeartRate = 0
        localCache.tutorialAnxiety = 0
    }
    
    func proceed() {
        coordinatorDelegate?.proceedFromWelcome()
    }

}
