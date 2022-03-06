//
//  PasswordService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol PasswordService {
    func sendPasswordReset(email: String, handler: @escaping (Error?) -> Void)
}

class PasswordAPIService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension PasswordAPIService: PasswordService {
    
    func sendPasswordReset(email: String, handler: @escaping (Error?) -> Void) {
        apiClient.sendPasswordReset(email: email, handler: handler)
    }

}
