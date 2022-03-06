//
//  FBUser.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBUser: Codable {
    var uid: String
    var age: Int
    var gender: String
    var nickname: String?
    var stats: FBUserStats
    var triggers: [String]
    
    init(model: PanicMechanicUser) {
        self.uid = model.uid
        self.age = model.age
        self.gender = model.gender.rawValue
        self.nickname = model.nickname
        self.stats = FBUserStats(model: model.stats)
        self.triggers = model.triggers
    }
    
}
