//
//  AuthOnboardViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class AuthOnboardViewModel: AuthOnboardViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: AuthOnboardViewModelCoordinatorDelegate?
    weak var viewDelegate: AuthOnboardViewModelViewDelegate?
    
        
    func start() {}
    
    func chooseLogIn() {
        coordinatorDelegate?.didChooseLogIn()
    }
    
    func chooseRegister() {
        coordinatorDelegate?.didChooseRegister()
    }
    
}


