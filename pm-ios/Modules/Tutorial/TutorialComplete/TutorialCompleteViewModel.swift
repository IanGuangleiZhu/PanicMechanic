//
//  TutorialCompleteViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class TutorialCompleteViewModel: TutorialCompleteViewModelType {
    
    weak var coordinatorDelegate: TutorialCompleteViewModelCoordinatorDelegate?
    weak var viewDelegate: TutorialCompleteViewModelViewDelegate?
    
    func start() {}
    
    func skip() {
        coordinatorDelegate?.proceedFromComplete()
    }

}
