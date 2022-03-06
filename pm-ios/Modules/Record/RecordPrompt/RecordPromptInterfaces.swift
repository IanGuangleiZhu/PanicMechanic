//
//  RecordPromptInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol RecordPromptViewModelType {
    
    var viewDelegate: RecordPromptViewModelViewDelegate? { get set }
    var coordinatorDelegate: RecordPromptViewModelCoordinatorDelegate? { get set }

    func start()
    
    func proceed()
    func startTutorial()
    func stopTutorial()
}

protocol RecordPromptViewModelCoordinatorDelegate: class {
    
    func proceedFromPrompt()

}

protocol RecordPromptViewModelViewDelegate: class {
    func updateProgressBar(progress: Float)
    func updateRecoveryLabel(duration: Double)
    func showCoachMarks()
    func hideCoachMarks()
    
}
