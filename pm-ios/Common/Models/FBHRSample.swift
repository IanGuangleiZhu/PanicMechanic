//
//  FBHRSample.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBHRSample: Codable {
    var bpm: Int
    var ts: Timestamp
    
    init(model: PanicMechanicHRSample) {
        self.bpm = model.bpm
        self.ts = Timestamp(date: model.ts)
    }
    
}
