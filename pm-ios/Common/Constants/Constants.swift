//
//  Constants.swift
//  pm-ios
//
//  Created by Synbrix Software on 9/11/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

// MARK: Structs -


// MARK: Enums -
enum StepType { case record, rating, survey, prompt }
enum RatingQuestionType: String { case anxiety, sleep, stress, diet, exercise, substances }
//extension RatingQuestionType: Codable {
//
//    enum CodingKeys: CodingKey {
//        case anxiety
//        case sleep
//        case stress
//        case diet
//        case exercise
//        case substances
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .left(let value):
//            try container.encode(value, forKey: .left)
//        case .right(let value):
//            try container.encode(value, forKey: .right)
//        }
//    }
//
//    init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        do {
////            let leftValue =  try container.decode(A.self, forKey: .left)
////            self = .left(leftValue)
////        } catch {
////            let rightValue =  try container.decode(B.self, forKey: .right)
////            self = .right(rightValue)
////        }
//    }
//
//
//}

//@IBAction func saveUserDefaults(_ sender: Any) {
//    let player = Player(name: "Axel", highScore: 42)
//    let defaults = UserDefaults.standard
//
//    // Use PropertyListEncoder to convert Player into Data / NSData
//    defaults.set(try? PropertyListEncoder().encode(player), forKey: "player")
//}
//
//@IBAction func loadUserDefaults(_ sender: Any) {
//    let defaults = UserDefaults.standard
//    guard let playerData = defaults.object(forKey: "player") as? Data else {
//        return
//    }
//
//    // Use PropertyListDecoder to convert Data into Player
//    guard let player = try? PropertyListDecoder().decode(Player.self, from: playerData) else {
//        return
//    }
//
//    print("player name is \(player.name)")
//}


enum PanicStep {
    case idle
    case record(Bool)
    case score
    case question
    case prompt
}

enum SurveyQuestion {
    case none
    case trigger
    case sleep
    case diet
    case exercise
    case stress
    case substances
}

enum SessionSetupResult {
    case success(RecordingState)
    case notAuthorized
    case configurationFailed
}

enum RecordingState {
    case recording(RecordingStepState)
    case notRecording
}

enum FingerDetectionState {
    case detected
    case notDetected
}

enum RecordingStepState {
    case heartRate(FingerDetectionState)
    case anxiety
    case question(QuestionState)
    case prompt
}

enum QuestionState {
    case trigger
    case sleep
    case stress
    case diet
    case exercise
    case substances
}

// MARK: Equatable -
extension PanicStep: Equatable {}

func ==(lhs: PanicStep, rhs: PanicStep) -> Bool {
    switch (lhs, rhs) {
    case (let .record(complete1), let .record(complete2)):
        return complete1 && complete2
    case (.idle, .idle):
        return true
    case (.score, .score):
        return true
    case (.question, .question):
        return true
    case (.prompt, .prompt):
        return true
    default:
        return false
    }
}

extension SurveyQuestion: Equatable {}

func ==(lhs: SurveyQuestion, rhs: SurveyQuestion) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.trigger, .trigger):
        return true
    case (.sleep, .sleep):
        return true
    case (.diet, .diet):
        return true
    case (.exercise, .exercise):
        return true
    case (.stress, .stress):
        return true
    case (.substances, .substances):
        return true
    default:
        return false
    }
}
