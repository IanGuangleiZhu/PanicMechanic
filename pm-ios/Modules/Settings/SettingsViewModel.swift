//
//  SettingsViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class SettingsViewModel: SettingsViewModelType {
    
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    weak var viewDelegate: SettingsViewModelViewDelegate?
    
    fileprivate let service: SignOutService
    
    init(service: SignOutService) {
        self.service = service
    }
    
    func start() {
        createDataSource()
    }
    
    func signOut() {
        service.signOut() { error in
            if let error = error {
                print("error signing out: \(error.localizedDescription)")
            } else {
                self.coordinatorDelegate?.didSignOut()
            }
        }
    }
    
    func startTutorial() {
        self.coordinatorDelegate?.didStartTutorial()
    }
    
    private func createDataSource() {
        let section1: [TableViewItemViewModel] = [
            BaseCell(title: "Account", detail: nil) {
                self.coordinatorDelegate?.didChooseAccount()
            },
            BaseCell(title: "Custom Triggers", detail: nil) {
                self.coordinatorDelegate?.didChooseCustomTriggers()
            },
            BaseCell(title: "Calibration", detail: nil) {
                self.coordinatorDelegate?.didChooseCalibration()
            },
            BaseCell(title: "Tutorial", detail: nil) {
                self.viewDelegate?.showTutorialAlert()
            },
            BaseCell(title: "Terms of Service", detail: nil) {
                self.coordinatorDelegate?.didChooseTerms()
            }
        ]
        let section2: [TableViewItemViewModel] = [
            DestructiveCell(title: "Log Out") {
                self.viewDelegate?.showSignOutAlert()
            }
        ]
        let ds: [TableViewSectionMap] = [
            TableViewSectionMap(section: nil, items: section1, footer: nil),
            TableViewSectionMap(section: nil, items: section2, footer: nil)
        ]
        viewDelegate?.updateDataSource(ds: ds)
    }
        
}


