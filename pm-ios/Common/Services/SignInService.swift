//
//  SignInService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol SignInService {
    func signIn(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void)
    func reauthenticate(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void)
    func getUser(handler: @escaping (AuthenticatedUser?) -> Void)
}

class SignInAPIService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension SignInAPIService: SignInService {
    
    func signIn(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void) {
        apiClient.signIn(email: email, password: password, handler: handler)
    }
    
    func reauthenticate(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void) {
        apiClient.reauthenticateUser(email: email, password: password, handler: handler)
    }
    
    func getUser(handler: @escaping (AuthenticatedUser?) -> Void) {
        apiClient.getUser(handler: handler)
    }

}
