//
//  AuthResetInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol AuthResetViewModelType {
    
    var viewDelegate: AuthResetViewModelViewDelegate? { get set }
    var coordinatorDelegate: AuthResetViewModelCoordinatorDelegate? { get set }

    func start()
    
    func submitEmail(email: String)
}

protocol AuthResetViewModelCoordinatorDelegate: class {
    
    func proceedFromReset()

}

protocol AuthResetViewModelViewDelegate: class {
    
    func showSuccess()
    func showError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}
