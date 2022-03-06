//
//  Questions.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct Questions {
    
    static let anxietyTitle = "Right at this moment, how would you rate your anxiety on a scale from 1-10?\n(10 being the most anxious you’ve ever felt)"
    static let anxietyInstructions = "(10 being the most anxious you’ve ever felt)"
    static let anxietyOptions = ["1","2","3","4","5","6","7","8","9","10"]
    static let triggerTitle = "Which of the following most relate to your current panic attack?"
    static let triggerInstructions = "Tap the + button to add your own."
    static let triggerOptions = ["Caffeine or Other Substance", "Conflict", "Finances", "Health", "Performance", "Physical Surroundings", "Social Situation", "Workload"]
    static let stressTitle = "Compared to your typical day, rate the following for the past 24 hours.\n\n%@"
    static let stressInstructions = "Stress Level"
    static let stressOptions = ["A Lot Worse", "Slightly Worse", "Typical", "Slightly Better", "A Lot Better"]
    static let sleepTitle = "Compared to your typical day, rate the following for the past 24 hours.\n\n%@"
    static let sleepInstructions = "Sleep Quality"
    static let sleepOptions = ["A Lot Worse", "Slightly Worse", "Typical", "Slightly Better", "A Lot Better"]
    static let exerciseTitle = "Compared to your typical day, rate the following for the past 24 hours.\n\n%@"
    static let exerciseInstructions = "Exercise Amount"
    static let exerciseOptions = ["A Lot Less", "Slightly Less", "Typical", "Slightly More", "A Lot More"]
    static let dietTitle = "Compared to your typical day, rate the following for the past 24 hours.\n\n%@"
    static let dietInstructions = "Eating Habits"
    static let dietOptions = ["A Lot Worse", "Slightly Worse", "Typical", "Slightly Better", "A Lot Better"]
    static let substancesTitle = "Compared to your typical day, rate the following for the past 24 hours.\n\n%@"
    static let substancesInstructions = "Drug/Alcohol Consumption"
    static let substancesOptions = ["A Lot More", "Slightly More", "Typical", "Slightly Less", "A Lot Less"]
    
    static func titleFor(questionType: RatingQuestionType) -> String {
        switch questionType {
        case .anxiety: return anxietyTitle
        case .stress: return stressTitle
        case .sleep: return sleepTitle
        case .diet: return dietTitle
        case .exercise: return exerciseTitle
        case .substances: return substancesTitle
        }
    }
    
    static func instructionsFor(questionType: RatingQuestionType) -> String {
        switch questionType {
        case .anxiety: return anxietyInstructions
        case .stress: return stressInstructions
        case .sleep: return sleepInstructions
        case .diet: return dietInstructions
        case .exercise: return exerciseInstructions
        case .substances: return substancesInstructions
        }
    }
    
    static func optionsFor(questionType: RatingQuestionType) -> [String] {
        switch questionType {
        case .anxiety: return anxietyOptions
        case .stress: return stressOptions
        case .sleep: return sleepOptions
        case .diet: return dietOptions
        case .exercise: return exerciseOptions
        case .substances: return substancesOptions
        }
    }

    
}
