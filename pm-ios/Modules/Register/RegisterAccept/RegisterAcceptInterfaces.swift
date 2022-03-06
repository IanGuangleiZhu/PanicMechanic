//
//  RegisterAcceptInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

// MARK: - Model Type
protocol RegisterAcceptViewModelType {
    
    var viewDelegate: RegisterAcceptViewModelViewDelegate? { get set }
    var coordinatorDelegate: RegisterAcceptViewModelCoordinatorDelegate? { get set }
    
    var shouldShowControls: Bool { get }

    func start()
    func acceptTerms()
    
}

// MARK: - Coordinator Delegate
protocol RegisterAcceptViewModelCoordinatorDelegate: class {
    
    func proceedFromAccept(with user: UnregisteredUser)

}

// MARK: - View Delegate
protocol RegisterAcceptViewModelViewDelegate: class {}
