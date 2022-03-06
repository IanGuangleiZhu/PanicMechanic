//
//  SignOutService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol SignOutService {
    func signOut(handler: @escaping (Error?) -> Void)
}

class SignOutAPIService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension SignOutAPIService: SignOutService {
    
    func signOut(handler: @escaping (Error?) -> Void) {
        apiClient.signOut(handler: handler)
    }

}
