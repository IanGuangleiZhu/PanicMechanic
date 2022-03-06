//
//  SignUpService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol SignUpService {
    func register(email: String, password: String, handler: @escaping (Error?) -> Void)
    func verify(handler: @escaping (Error?) -> Void)
    func isVerified(handler: @escaping (Bool) -> Void)
    func applyVerificationCode(code: String, handler: @escaping (Error?) -> Void)
    func reloadUser(handler: @escaping (Error?) -> Void)
}

class SignUpAPIService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension SignUpAPIService: SignUpService {

    func register(email: String, password: String, handler: @escaping (Error?) -> Void) {
        apiClient.register(email: email, password: password) { error in
            handler(error)
        }
    }
    
    func verify(handler: @escaping (Error?) -> Void) {
        apiClient.sendVerificationEmail { error in
            handler(error)
        }
    }
    
    func isVerified(handler: @escaping (Bool) -> Void) {
        apiClient.getUser { user in
            if let user = user, user.verified {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    func applyVerificationCode(code: String, handler: @escaping (Error?) -> Void) {
        apiClient.applyVerificationCode(code: code, handler: handler)
    }
    
    func reloadUser(handler: @escaping (Error?) -> Void) {
        apiClient.reloadUser(handler: handler)
    }
    

}
