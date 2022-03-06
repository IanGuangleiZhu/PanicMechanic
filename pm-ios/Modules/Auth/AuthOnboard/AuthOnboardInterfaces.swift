//
//  AuthOnboardInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol AuthOnboardViewModelType {
    
    var viewDelegate: AuthOnboardViewModelViewDelegate? { get set }
    var coordinatorDelegate: AuthOnboardViewModelCoordinatorDelegate? { get set }

    func start()
    
    func chooseLogIn()
    func chooseRegister()
}

protocol AuthOnboardViewModelCoordinatorDelegate: class {
    
    func presentVerification(with user: AuthenticatedUser)    
    func didChooseLogIn()
    func didChooseRegister()
    
}

protocol AuthOnboardViewModelViewDelegate: class {}
