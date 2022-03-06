//
//  Notifications.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/17/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var stopRunning: Notification.Name {
        return .init(rawValue: "AVCaptureSession.stopRunning")
    }
    
    static var startRunning: Notification.Name {
        return .init(rawValue: "AVCaptureSession.startRunning")
    }
    
    static var attackStarted: Notification.Name {
        return .init(rawValue: "WePanic.attackStarted")
    }
    
    static var attackEnded: Notification.Name {
        return .init(rawValue: "WePanic.attackEnded")
    }
    
    static var attackPaused: Notification.Name {
        return .init(rawValue: "WePanic.attackPaused")
    }
    
    static var attackResumed: Notification.Name {
        return .init(rawValue: "WePanic.attackResumed")
    }
    
    static var attackCompleted: Notification.Name {
        return .init(rawValue: "WePanic.attackCompleted")
    }
    
    static var newStepBegan: Notification.Name {
        return .init(rawValue: "WePanic.newStepBegan")
    }
}


extension Notification.Name {
    static var heartRateReceived: Notification.Name {
        return .init(rawValue: "WePanic.heartRateReceived")
    }
    
    static var anxietyRated: Notification.Name {
        return .init(rawValue: "WePanic.anxietyRated")
    }
    static var sleepRated: Notification.Name {
        return .init(rawValue: "WePanic.sleepRated")
    }
    static var dietRated: Notification.Name {
        return .init(rawValue: "WePanic.dietRated")
    }
    static var exerciseRated: Notification.Name {
        return .init(rawValue: "WePanic.exerciseRated")
    }
    static var stressRated: Notification.Name {
        return .init(rawValue: "WePanic.stressRated")
    }
    static var substanceRated: Notification.Name {
        return .init(rawValue: "WePanic.substanceRated")
    }
    static var dateChanged: Notification.Name {
        return .init(rawValue: "WePanic.dateChanged")
    }
}

extension Notification.Name {
    
    static var triggerSubmitted: Notification.Name {
        return .init(rawValue: "WePanic.triggerSubmitted")
    }
    static var userLoaded: Notification.Name {
        return .init(rawValue: "WePanic.userLoaded")
    }
    static var practiceModeChanged: Notification.Name {
        return .init(rawValue: "WePanic.practiceModeChanged")
    }
}
