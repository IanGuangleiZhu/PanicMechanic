//
//  AuthResetViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class AuthResetViewModel: AuthResetViewModelType {
    
    weak var coordinatorDelegate: AuthResetViewModelCoordinatorDelegate?
    weak var viewDelegate: AuthResetViewModelViewDelegate?
    
    private let passwordService: PasswordService

    init(passwordService: PasswordService, deepLink: DeepLink? = nil) {
        self.passwordService = passwordService
    }
        
    func start() {}
    
    func submitEmail(email: String) {
        // TODO: Check if email in valid format
        viewDelegate?.showLoadingIndicator()
        passwordService.sendPasswordReset(email: email) { error in
            self.viewDelegate?.hideLoadingIndicator()
            if let error = error {
                self.viewDelegate?.showError(message: error.localizedDescription)
            } else {
                self.viewDelegate?.showSuccess()
            }
        }
    }
    
}
