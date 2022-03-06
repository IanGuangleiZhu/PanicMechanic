//
//  UserDefaultsClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import CoreLocation

class UserDefaultsClient: LocalCache {
    
    private static let DEFAULT_SENSITIVITY: Double = 1400000
    
    private enum ClientKeys: String {
        case tutorialComplete = "tutorialComplete"
        case practiceModeEnabled = "practiceModeEnabled"
        case currentCycleCount = "currentCycleCount"
        case sensitivity = "sensitivity"
        case tutorialHeartRate = "tutorialHeartRate"
        case tutorialAnxiety = "tutorialAnxiety"
        case attackStartTimestamp = "attackStartTimestamp"
        case attackStopTimestamp = "attackStopTimestamp"
        case cycleStartTimestamp = "cycleStartTimestamp"
        case cycleIndex = "cycleIndex"
    }
    
    var isTutorialComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ClientKeys.tutorialComplete.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.tutorialComplete.rawValue)
        }
    }
    
    var practiceModeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ClientKeys.practiceModeEnabled.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.practiceModeEnabled.rawValue)
        }
    }
    
    var currentCycleCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: ClientKeys.currentCycleCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.currentCycleCount.rawValue)
        }
    }
    
    var cameraSensitivity: Double {
        get {
            if UserDefaults.standard.double(forKey: ClientKeys.sensitivity.rawValue) == 0.0 {
                UserDefaults.standard.set(UserDefaultsClient.DEFAULT_SENSITIVITY, forKey: ClientKeys.sensitivity.rawValue)
            }
            return UserDefaults.standard.double(forKey: ClientKeys.sensitivity.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.sensitivity.rawValue)
        }
    }
    
    var tutorialHeartRate: Int {
        get {
            return UserDefaults.standard.integer(forKey: ClientKeys.tutorialHeartRate.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.tutorialHeartRate.rawValue)
        }
    }
    
    var tutorialAnxiety: Int {
        get {
            return UserDefaults.standard.integer(forKey: ClientKeys.tutorialAnxiety.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.tutorialAnxiety.rawValue)
        }
    }
    
    var attackStartTimestamp: Date? {
        get {
            return UserDefaults.standard.object(forKey: ClientKeys.attackStartTimestamp.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.attackStartTimestamp.rawValue)
        }
    }
    
    var attackStopTimestamp: Date? {
        get {
            return UserDefaults.standard.object(forKey: ClientKeys.attackStopTimestamp.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClientKeys.attackStopTimestamp.rawValue)
        }
    }
    
    var cycleStartTimestamp: Date? {
           get {
               return UserDefaults.standard.object(forKey: ClientKeys.cycleStartTimestamp.rawValue) as? Date
           }
           set {
               UserDefaults.standard.set(newValue, forKey: ClientKeys.cycleStartTimestamp.rawValue)
           }
       }
    
    var cycleIndex: Int {
           get {
               return UserDefaults.standard.integer(forKey: ClientKeys.cycleIndex.rawValue)
           }
           set {
               UserDefaults.standard.set(newValue, forKey: ClientKeys.cycleIndex.rawValue)
           }
       }
}
