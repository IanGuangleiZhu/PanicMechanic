//
//  AuthLoginViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class AuthLoginViewModel: AuthLoginViewModelType {

    weak var coordinatorDelegate: AuthLoginViewModelCoordinatorDelegate?
    weak var viewDelegate: AuthLoginViewModelViewDelegate?
    
    private let signInService: SignInService

    init(signInService: SignInService) {
        self.signInService = signInService
    }
    
    func start() {}
    
    func logIn(email: String, password: String) {
        viewDelegate?.showLoadingIndicator()
        signInService.signIn(email: email, password: password) { user, error in
            self.viewDelegate?.hideLoadingIndicator()
            if let error = error {
                self.viewDelegate?.showError(message: error.localizedDescription)
            } else {
                if let _ = user {
                    self.coordinatorDelegate?.didLogIn()
                } else {
                    self.viewDelegate?.showError(message: "Failed to unpack user")
                }
            }
         }
         
    }
    
    func chooseForgotPassword() {
        self.coordinatorDelegate?.didForgetPassword()
    }
    
    func chooseRegister() {
         
     }
    
}


