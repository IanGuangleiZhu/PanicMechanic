//
//  RecordRatingInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol RecordRatingViewModelType {
    
    var viewDelegate: RecordRatingViewModelViewDelegate? { get set }
    var coordinatorDelegate: RecordRatingViewModelCoordinatorDelegate? { get set }
    
    func start()
    
    func proceed(with rating: Int)
    func startTutorial()
    func stopTutorial()
    func getQuestionType() -> RatingQuestionType
    func mapValueToOption(value: Int) -> String
}

protocol RecordRatingViewModelCoordinatorDelegate: class {
    
    func proceedFromAnxietyQuestion()
    func proceedFromQualityQuestion()

}

protocol RecordRatingViewModelViewDelegate: class {
    func updateProgressBar(progress: Float)
    func updateTitle(title: String)
    func updateQuestion(title: String, instructions: String, options: [String])
    func showCoachMarks()
    func hideCoachMarks()
    
}
