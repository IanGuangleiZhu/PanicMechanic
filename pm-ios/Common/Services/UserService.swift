//
//  UserService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

protocol UserService {
    func addUser(user: PanicMechanicUser, handler: @escaping (Error?) -> Void)
    func addUser(age: Int, gender: String, nickname: String?, handler: @escaping (Error?) -> Void)
    func updateNickname(nickname: String, handler: @escaping (Error?) -> Void)
    func updateTriggers(user: PanicMechanicUser, triggers: [String], handler: @escaping (Error?) -> Void)
    func deleteUser(handler: @escaping (Error?) -> Void)
    func loadUser(handler: @escaping (PanicMechanicUser?, Error?) -> Void)
}

class UserAPIService {
    
    let apiClient: APIClient
//    let coreDataClient: CoreDataClient
    
    init(apiClient: APIClient) { //, coreDataClient: CoreDataClient) {
        self.apiClient = apiClient
//        self.coreDataClient = coreDataClient
    }
    
}

// MARK: - API
extension UserAPIService: UserService {
    
    func addUser(user: PanicMechanicUser, handler: @escaping (Error?) -> Void) {
        apiClient.getUser { au in
            if let _ = au {
                self.apiClient.addUser(user: user, handler: handler)
            } else {
                log.error("Failed to get authorized user.")
            }
        }
    }
    
    func addUser(age: Int, gender: String, nickname: String?, handler: @escaping (Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.addUser(uid: user.uid, age: age, gender: gender, nickname: nickname, handler: handler)
            } else {
                log.error("Failed to get authorized user.")
            }
        }
    }
    
    func updateNickname(nickname: String, handler: @escaping (Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.updateNickname(uid: user.uid, nickname: nickname, handler: handler)
            } else {
                print("failed to update nickname for user")
            }
        }
    }
    
    func updateTriggers(user: PanicMechanicUser, triggers: [String], handler: @escaping (Error?) -> Void) {
        self.apiClient.updateTriggers(uid: user.uid, triggers: triggers, handler: handler)
    }
    
    func deleteUser(handler: @escaping (Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.deleteUser(uid: user.uid, handler: handler)
            } else {
                print("failed to delete user")
            }
        }
    }
    
    func loadUser(handler: @escaping (PanicMechanicUser?, Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                log.info("Loaded user: \(user) in user service")
                self.apiClient.loadUser(uid: user.uid, handler: handler)
            } else {
                print("failed to load user")
            }
        }
    }
    
}
