//
//  FBLocation.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBLocation: Codable {
    var name: String
    var coordinate: GeoPoint
    
    init(model: PanicMechanicLocation) {
        self.name = model.name
        self.coordinate = GeoPoint(latitude: model.latitude, longitude: model.longitude)
    }
    
}

