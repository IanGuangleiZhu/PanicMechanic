//
//  AccountInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol AccountViewModelType {
    
    var viewDelegate: AccountViewModelViewDelegate? { get set }
    var coordinatorDelegate: AccountViewModelCoordinatorDelegate? { get set }
    
    func start()
    func deleteAccount()
    func reauthenticate()
}

protocol AccountViewModelCoordinatorDelegate: class {

    func showReauthentication()
    func didDeleteAccount()
}

protocol AccountViewModelViewDelegate: class {
    
    func updateDataSource(item: String?)
    func showDeleteAccountAlert()
    func showError(message: String)
}
