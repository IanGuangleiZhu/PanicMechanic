//
//  Coordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    func start()
    func start(deepLink: DeepLink)
    func finish()
}
