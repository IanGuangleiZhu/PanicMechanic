//
//  FBAnxietySample.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBAnxietySample: Codable {
    var rating: Int
    var ts: Timestamp
    
    init(model: PanicMechanicAnxietySample) {
        self.rating = model.rating
        self.ts = Timestamp(date: model.ts)
    }
    
}
