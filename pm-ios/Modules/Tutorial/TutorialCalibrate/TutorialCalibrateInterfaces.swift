//
//  TutorialCalibrateInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TutorialCalibrateViewModelType {
    
    var viewDelegate: TutorialCalibrateViewModelViewDelegate? { get set }
    var coordinatorDelegate: TutorialCalibrateViewModelCoordinatorDelegate? { get set }
    
    var shouldShowNextButton: Bool { get }
    var shouldShowBackButton: Bool { get }
    var shouldShowInfoLabel: Bool { get }
    func start()
    
    func proceed()
    func teardown()
    func update(sensitivity: Double)

}

protocol TutorialCalibrateViewModelCoordinatorDelegate: class {
    
    func proceedFromCalibrate()
    
}

protocol TutorialCalibrateViewModelViewDelegate: class {

    func updateDetectedLabel(isDetected: Bool)
    func updateSlider(value: Float)
    
}
