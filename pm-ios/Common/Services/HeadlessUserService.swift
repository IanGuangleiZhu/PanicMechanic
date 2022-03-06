//
//  HeadlessUserService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol HeadlessUserService {
    func loadLatestHeadlessUser(handler: @escaping (HeadlessUser?, Error?) -> Void)
    func create(age: Int, gender: String, nickname: String?)
    func deleteHeadlessUsers(handler: @escaping (Error?) -> Void)
}

class HeadlessUserAPIService {
    
    let localStore: LocalStore
    
    init(localStore: LocalStore) {
        self.localStore = localStore
    }
    
}

// MARK: - API
extension HeadlessUserAPIService: HeadlessUserService {
    
    // Fetching
    func loadLatestHeadlessUser(handler: @escaping (HeadlessUser?, Error?) -> Void) {
        localStore.fetchHeadlessUser(context: localStore.backgroundContext, handler: handler)
    }
    
    // Saving
    func create(age: Int, gender: String, nickname: String?) {
        #if DEBUG
            log.info("Creating new headless user:", context: [age, gender, nickname ?? Strings.defaultNullDisplay])
        #endif
        localStore.backgroundContext.performAndWait {
            let user = HeadlessUser(context: localStore.backgroundContext)
            user.age = Int16(age)
            user.gender = gender
            user.nickname = nickname
            user.lastUpdated = Date()
            localStore.save(with: self.localStore.backgroundContext)
        }
    }
    
    // Delete
    func deleteHeadlessUsers(handler: @escaping (Error?) -> Void) {
        localStore.deleteHeadlessUsers(context: localStore.backgroundContext, handler: handler)
    }
    
}
