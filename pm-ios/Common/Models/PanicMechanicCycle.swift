//
//  PanicMechanicCycle.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicCycle: Codable {
    var hr: PanicMechanicHRSample?
    var anxiety: PanicMechanicAnxietySample?
    var question: PanicMechanicQuestion?
    var endTs: Date
    
    enum CodingKeys: String, CodingKey {
        case hr
        case anxiety
        case question
        case endTs = "end_ts"
    }
    
    init(hr: PanicMechanicHRSample?, anxiety: PanicMechanicAnxietySample?, question: PanicMechanicQuestion?, endTs: Date) {
        self.hr = hr
        self.anxiety = anxiety
        self.question = question
        self.endTs = endTs
    }
    
    init(model: FBCycle) {
        if let hr = model.hr {
            self.hr = PanicMechanicHRSample(model: hr)
        }
        if let anxiety = model.anxiety {
            self.anxiety = PanicMechanicAnxietySample(model: anxiety)
        }
        if let question = model.question {
            self.question = PanicMechanicQuestion(model: question)
        }
        self.endTs = model.endTs.dateValue()
    }
}

extension PanicMechanicCycle {
    
    func scaleHR(scaler: Int) -> Int {
        return scaler
    }
    
}
