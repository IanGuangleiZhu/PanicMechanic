//
//  LocalCache.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol LocalCache {
    var isTutorialComplete: Bool { get set }
    var cameraSensitivity: Double { get set }
    var tutorialHeartRate: Int { get set }
    var tutorialAnxiety: Int { get set }
    var practiceModeEnabled: Bool { get set }
    var currentCycleCount: Int { get set }
    var attackStartTimestamp: Date? { get set }
    var attackStopTimestamp: Date? { get set }
    var cycleStartTimestamp: Date? { get set }
    var cycleIndex: Int { get set } 
}
