//
//  AccountViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import FirebaseAuth

class AccountViewModel: AccountViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: AccountViewModelCoordinatorDelegate?
    weak var viewDelegate: AccountViewModelViewDelegate?
    
    // MARK: - Dependencies -
    private let apiClient: APIClient
    

    // MARK: - Lifecycle -
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func start() {
        loadAccount()
    }
    
    private func loadAccount() {
        apiClient.getUser { user in
            self.viewDelegate?.updateDataSource(item: user?.email)
        }
    }
    
    func deleteAccount() {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.deleteUser(uid: user.uid) { error in
                    if let error = error as NSError? {
                        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                            log.error("Could not serialize error code:", context: error)
                            return
                        }
                        switch errorCode {
                        case .requiresRecentLogin:
                            log.error("Error encountered while deleting account, needs recent login.", context: error)
                            self.viewDelegate?.showError(message: error.localizedDescription)
                        default:
                            log.error("Error encountered while deleting account.", context: error)
                        }
                        return
                    }
                    self.coordinatorDelegate?.didDeleteAccount()
                }
            } else {
                log.error("Unable to get current user.")
            }
        }
    }
    
    func reauthenticate() {
        self.coordinatorDelegate?.showReauthentication()
    }

}


