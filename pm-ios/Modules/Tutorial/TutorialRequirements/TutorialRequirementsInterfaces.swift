//
//  TutorialRequirementsInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TutorialRequirementsViewModelType {
    
    var viewDelegate: TutorialRequirementsViewModelViewDelegate? { get set }
    var coordinatorDelegate: TutorialRequirementsViewModelCoordinatorDelegate? { get set }

    func start()
    
    func proceed()
    func requestLocationAccess()
    func requestCameraAccess()
}

protocol TutorialRequirementsViewModelCoordinatorDelegate: class {
    
    func proceedFromRequirements()
    
}

protocol TutorialRequirementsViewModelViewDelegate: class {
    
    func updateCameraSwitch(isOn: Bool)
    func updateLocationSwitch(isOn: Bool)

}
