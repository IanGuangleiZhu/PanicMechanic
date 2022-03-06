//
//  Timeable.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat

protocol Timeable {
    var timer: Repeater? { get set }
    func startTimer()
    func stopTimer()
}
