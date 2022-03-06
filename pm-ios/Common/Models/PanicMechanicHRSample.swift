//
//  PanicMechanicHRSample.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicHRSample: Codable {
    var bpm: Int
    var ts: Date
    
    init(bpm: Int, ts: Date) {
        self.bpm = bpm
        self.ts = ts
    }
    
    init(model: FBHRSample) {
        self.bpm = model.bpm
        self.ts = model.ts.dateValue()
    }
}
