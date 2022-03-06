//
//  PanicMechanicUser.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import FirebaseAuth

enum UserGender: String {
    case male = "MALE"
    case female = "FEMALE"
    case nonbinary = "NON-BINARY"
    case unknown = "UNKNOWN"
}

struct UserStats {
    var recoveryDuration: Double
    var totalAttacks: Int
    
    init(recoveryDuration: Double, totalAttacks: Int) {
        self.recoveryDuration = recoveryDuration
        self.totalAttacks = totalAttacks
    }
    
    init(model: FBUserStats) {
        self.recoveryDuration = model.recoveryDuration
        self.totalAttacks = model.totalAttacks
    }
}

protocol Identifiable {
    var uid: String { get set }
}

struct AuthenticatedUser: Identifiable {
    var uid: String
    var email: String
    var verified: Bool
}

struct UnregisteredUser {
    var email: String?
    var verified: Bool
    var age: Int?
    var gender: UserGender?
    var nickname: String?
    var termsAccepted: Bool
}

struct PanicMechanicUser: Identifiable {
    var uid: String
    var age: Int
    var gender: UserGender
    var nickname: String?
    var stats: UserStats
    var triggers: [String]
    
    init(model: FBUser) {
        self.uid = model.uid
        self.age = model.age
        self.gender = UserGender(rawValue: model.gender) ?? .unknown
        self.nickname = model.nickname
        self.stats = UserStats(model: model.stats)
        self.triggers = model.triggers
    }
    
    init(uid: String, age: Int, gender: UserGender, nickname: String?, stats: UserStats, triggers: [String]) {
        self.uid = uid
        self.age = age
        self.gender = gender
        self.nickname = nickname
        self.stats = stats
        self.triggers = triggers
    }
    
}
