//
//  RegisterAcceptViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class RegisterAcceptViewModel {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: RegisterAcceptViewModelCoordinatorDelegate?
    weak var viewDelegate: RegisterAcceptViewModelViewDelegate?
    
    // MARK: - Dependencies
    private let isRegister: Bool
    
    // MARK: - Lifecycle
    init(isRegister: Bool) {
        self.isRegister = isRegister
    }
}

// MARK: - Model Type
extension RegisterAcceptViewModel: RegisterAcceptViewModelType {
    
    var shouldShowControls: Bool {
        return isRegister
    }
    
    func start() {}
    
    func acceptTerms() {
        let user = UnregisteredUser(email: nil, verified: false, age: nil, gender: nil, nickname: nil, termsAccepted: true)
        log.info("User post-terms:", context: user)
        coordinatorDelegate?.proceedFromAccept(with: user)
    }
    
}
