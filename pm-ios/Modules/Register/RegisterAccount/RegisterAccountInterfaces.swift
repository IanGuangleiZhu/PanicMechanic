//
//  RegisterAccountInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol RegisterAccountViewModelType {
    
    var viewDelegate: RegisterAccountViewModelViewDelegate? { get set }
    var coordinatorDelegate: RegisterAccountViewModelCoordinatorDelegate? { get set }

    func start()
    
    func register(email: String, password: String)
    func sendEmailVerification()
}

protocol RegisterAccountViewModelCoordinatorDelegate: class {}

protocol RegisterAccountViewModelViewDelegate: class {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: String)
}
