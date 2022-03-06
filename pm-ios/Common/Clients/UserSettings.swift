//
//  UserSettings.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/6/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class UserSettings {
    
    static func save(firstLoginTimestamp: Date) {
         UserDefaults.standard.set(firstLoginTimestamp.timeIntervalSince1970, forKey: "FirstLoginTS")
    }
    
    static func getFirstLoginTimestamp() -> Double {
        return UserDefaults.standard.double(forKey: "FirstLoginTS")
    }
    
    static func save(sensitivity: Double) {
        UserDefaults.standard.set(sensitivity, forKey: "Sensitivity")
    }
    
    static func getSensitivity() -> Double {
        return UserDefaults.standard.double(forKey: "Sensitivity")
    }
    
    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")

        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")

        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDict")
        
//        let age = defaults.integer(forKey: "Age")
//        let useTouchID = defaults.bool(forKey: "UseTouchID")
//        let pi = defaults.double(forKey: "Pi")
//        
//        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()

    }
    
}
