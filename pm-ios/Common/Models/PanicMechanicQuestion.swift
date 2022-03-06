//
//  PanicMechanicQuestion.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct PanicMechanicQuestion: Codable {
    var name: String
    var answer: String
    
    init(name: String, answer: String) {
        self.name = name
        self.answer = answer
    }
    
    init(model: FBQuestion) {
        self.name = model.name
        self.answer = model.answer
    }
}
