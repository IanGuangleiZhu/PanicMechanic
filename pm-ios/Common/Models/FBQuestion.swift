//
//  FBQuestion.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import FirebaseFirestore

struct FBQuestion: Codable {
    var name: String
    var answer: String
    
    init(model: PanicMechanicQuestion) {
        self.name = model.name
        self.answer = model.answer
    }
    
}
