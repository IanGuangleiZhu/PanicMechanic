//
//  PanicMechanicLocation.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(model: FBLocation) {
        self.name = model.name
        self.latitude = model.coordinate.latitude
        self.longitude = model.coordinate.longitude
    }
}
