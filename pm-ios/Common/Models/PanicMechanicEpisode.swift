//
//  Episode.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicEpisode: Codable {
    var uid: String
    var startTs: Date
    var stopTs: Date
    var updatedAt: Date
    var location: PanicMechanicLocation?
    var cycles: [PanicMechanicCycle]
    
    enum CodingKeys: String, CodingKey {
        case uid
        case startTs = "start_ts"
        case stopTs = "stop_ts"
        case updatedAt = "updated_at"
        case location
        case cycles
    }
    
    init(uid: String, startTs: Date, stopTs: Date, updatedAt: Date, location: PanicMechanicLocation?, cycles: [PanicMechanicCycle]) {
        self.uid = uid
        self.startTs = startTs
        self.stopTs = stopTs
        self.updatedAt = updatedAt
        self.location = location
        self.cycles = cycles
    }
    
    init(model: FBEpisode) {
        self.uid = model.uid
        self.startTs = model.startTs.dateValue()
        self.stopTs = model.stopTs.dateValue()
        self.updatedAt = model.updatedAt.dateValue()
        if let location = model.location {
            self.location = PanicMechanicLocation(model: location)
        }
        self.cycles = model.cycles.map { PanicMechanicCycle(model: $0) }
    }
}


