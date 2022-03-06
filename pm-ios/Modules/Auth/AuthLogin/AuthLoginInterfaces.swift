//
//  AuthLoginInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol AuthLoginViewModelType {
    
    var viewDelegate: AuthLoginViewModelViewDelegate? { get set }
    var coordinatorDelegate: AuthLoginViewModelCoordinatorDelegate? { get set }

    func start()
    func logIn(email: String, password: String)
    func chooseForgotPassword()
    func chooseRegister()
}

protocol AuthLoginViewModelCoordinatorDelegate: class {
    
    func didLogIn()
    func didForgetPassword()
    
}

protocol AuthLoginViewModelViewDelegate: class {
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: String)
    
}
