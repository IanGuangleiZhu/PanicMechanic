//
//  TabBarViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TabBarViewModelType {
    
    var viewDelegate: TabBarViewModelViewDelegate? { get set }
    var coordinatorDelegate: TabBarViewModelCoordinatorDelegate? { get set }

    func start()
    
}

protocol TabBarViewModelCoordinatorDelegate: class {
    
    
}

protocol TabBarViewModelViewDelegate: class {

    
}

class TabBarViewModel: TabBarViewModelType {
    
    weak var coordinatorDelegate: TabBarViewModelCoordinatorDelegate?
    weak var viewDelegate: TabBarViewModelViewDelegate?
    
    deinit {
        print("deallocing \(self)")
    }
    
    func start() {
    }
    
}


