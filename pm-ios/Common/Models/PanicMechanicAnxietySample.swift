//
//  PanicMechanicAnxietySample.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicAnxietySample: Codable {
    var rating: Int
    var ts: Date
    
    init(rating: Int, ts: Date) {
        self.rating = rating
        self.ts = ts
    }
    
    init(model: FBAnxietySample) {
        self.rating = model.rating
        self.ts = model.ts.dateValue()
    }
}
