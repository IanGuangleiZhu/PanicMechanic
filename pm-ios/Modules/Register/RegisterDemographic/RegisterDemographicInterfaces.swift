//
//  RegisterDemographicInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

// MARK: - Model Type
protocol RegisterDemographicViewModelType {
    
    var viewDelegate: RegisterDemographicViewModelViewDelegate? { get set }
    var coordinatorDelegate: RegisterDemographicViewModelCoordinatorDelegate? { get set }

    func start()
    func submitDemographics(gender: String, age: Int, nickname: String?)
}

// MARK: - Coordinator Delegate
protocol RegisterDemographicViewModelCoordinatorDelegate: class {
    
    func proceedFromDemographics(with user: UnregisteredUser)
        
}

// MARK: - View Delegate
protocol RegisterDemographicViewModelViewDelegate: class {}
