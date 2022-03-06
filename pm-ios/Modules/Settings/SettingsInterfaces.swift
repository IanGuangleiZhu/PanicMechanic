//
//  SettingsInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol SettingsViewModelType {
    
    var viewDelegate: SettingsViewModelViewDelegate? { get set }
    var coordinatorDelegate: SettingsViewModelCoordinatorDelegate? { get set }
    
    func start()
    
    func signOut()
    func startTutorial()
}

protocol SettingsViewModelCoordinatorDelegate: class {
    
    func didSignOut()
    func didStartTutorial()
    func didChooseTerms()
    func didChooseCalibration()
    func didChooseCustomTriggers()
    func didChooseAccount()

}

protocol SettingsViewModelViewDelegate: class {
    
    func updateDataSource(ds: [TableViewSectionMap])
    func showSignOutAlert()
    func showTutorialAlert()
    
}
