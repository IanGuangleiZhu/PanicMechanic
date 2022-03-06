//
//  FBEpisode.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBEpisode: Codable {
    var uid: String
    var startTs: Timestamp
    var stopTs: Timestamp
    var updatedAt: Timestamp
    var location: FBLocation?
    var cycles: [FBCycle]
    
    enum CodingKeys: String, CodingKey {
        case uid
        case startTs = "start_ts"
        case stopTs = "stop_ts"
        case updatedAt = "updated_at"
        case location
        case cycles
    }
    
    init(model: PanicMechanicEpisode) {
        self.uid = model.uid
        self.startTs = Timestamp(date: model.startTs)
        self.stopTs = Timestamp(date: model.stopTs)
        self.updatedAt = Timestamp(date: model.updatedAt)
        if let location = model.location {
            self.location = FBLocation(model: location)
        }
        self.cycles = model.cycles.map { FBCycle(model: $0) }
    }
}
