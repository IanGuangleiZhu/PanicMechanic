//
//  FBCycle.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBCycle: Codable {
    var hr: FBHRSample?
    var anxiety: FBAnxietySample?
    var question: FBQuestion?
    var endTs: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case hr
        case anxiety
        case question
        case endTs = "end_ts"
    }
    
    init(model: PanicMechanicCycle) {
        if let hr = model.hr {
            self.hr = FBHRSample(model: hr)
        }
        if let anxiety = model.anxiety {
            self.anxiety = FBAnxietySample(model: anxiety)
        }
        if let question = model.question {
            self.question = FBQuestion(model: question)
        }
        self.endTs = Timestamp(date: model.endTs)
    }
}
