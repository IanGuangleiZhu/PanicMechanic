//
//  FBUserStats.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBUserStats: Codable {
    var recoveryDuration: Double
    var totalAttacks: Int
    
    enum CodingKeys: String, CodingKey {
        case recoveryDuration = "recovery_duration"
        case totalAttacks = "total_attack"
    }
    
    init(model: UserStats) {
        self.recoveryDuration = model.recoveryDuration
        self.totalAttacks = model.totalAttacks
    }
}
