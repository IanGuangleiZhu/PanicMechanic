//
//  RecordQuestionInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/22/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol RecordQuestionViewModelType {
    
    var viewDelegate: RecordQuestionViewModelViewDelegate? { get set }
    var coordinatorDelegate: RecordQuestionViewModelCoordinatorDelegate? { get set }

    func start()
    
    func proceed()
    func pause()
    func resume()
    func addTrigger()
    func handle(trigger: String)
    func startTutorial()
    func stopTutorial()
    
    func numberSections() -> Int
    func numberRows(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> String?
    func didSelect(at indexPath: IndexPath)
    
}

protocol RecordQuestionViewModelCoordinatorDelegate: class {
    
    func proceedFromTriggerQuestion()

}

protocol RecordQuestionViewModelViewDelegate: class {
    func updateProgressBar(progress: Float)
    func reloadData()
    func showCoachMarks()
    func hideCoachMarks()
    func showAddCustomTriggerAlert()
    
}
