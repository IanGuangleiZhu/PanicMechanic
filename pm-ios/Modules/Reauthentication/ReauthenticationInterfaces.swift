//
//  ReauthenticationInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol ReauthenticationViewModelType {
    
    var viewDelegate: ReauthenticationViewModelViewDelegate? { get set }
    var coordinatorDelegate: ReauthenticationViewModelCoordinatorDelegate? { get set }
    
    func start()
    func reauthenticate(email: String, password: String)
    func cancel()
}

protocol ReauthenticationViewModelCoordinatorDelegate: class {
    
    func didReauthenticate()
    
}

protocol ReauthenticationViewModelViewDelegate: class {
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: String)

}
