//
//  ReauthenticationViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class ReauthenticationViewModel: ReauthenticationViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: ReauthenticationViewModelCoordinatorDelegate?
    weak var viewDelegate: ReauthenticationViewModelViewDelegate?
    
    // MARK: - Dependencies -
    private let signInService: SignInService
    

    // MARK: - Lifecycle -
    init(signInService: SignInService) {
        self.signInService = signInService
    }
    
    func start() {}
    
    func reauthenticate(email: String, password: String) {
        viewDelegate?.showLoadingIndicator()
        signInService.reauthenticate(email: email, password: password) { user, error in
            self.viewDelegate?.hideLoadingIndicator()
            if let error = error {
                self.viewDelegate?.showError(message: error.localizedDescription)
            } else {
                if let _ = user {
                    self.coordinatorDelegate?.didReauthenticate()
                } else {
                    self.viewDelegate?.showError(message: "Failed to find user.")
                }
            }
         }
    }
    
    func cancel() {
        coordinatorDelegate?.didReauthenticate()
    }

}
