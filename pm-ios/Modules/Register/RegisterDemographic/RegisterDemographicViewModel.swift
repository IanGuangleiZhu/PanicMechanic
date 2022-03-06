//
//  RegisterDemographicViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class RegisterDemographicViewModel {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: RegisterDemographicViewModelCoordinatorDelegate?
    weak var viewDelegate: RegisterDemographicViewModelViewDelegate?
        
    // MARK: - Dependencies
    private var user: UnregisteredUser
    
    // MARK: - Lifecycle
    init(user: UnregisteredUser) {
        self.user = user
    }
    
}

// MARK: - Model Type
extension RegisterDemographicViewModel: RegisterDemographicViewModelType {
    
    func start() {}

    func submitDemographics(gender: String, age: Int, nickname: String?) {
        user.gender = UserGender(rawValue: gender)
        user.age = age
        user.nickname = nickname
        log.info("User post-demographics:", context: user)
        coordinatorDelegate?.proceedFromDemographics(with: user)
    }
    
}
