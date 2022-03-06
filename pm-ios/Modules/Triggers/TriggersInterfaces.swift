//
//  TriggersInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/25/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TriggersViewModelType {
    
    var viewDelegate: TriggersViewModelViewDelegate? { get set }
    var coordinatorDelegate: TriggersViewModelCoordinatorDelegate? { get set }
    
    var shouldShowEditButton: Bool { get }
    
    func start()
    func item(at index: Int) -> String?
    func removeTrigger(at indexPath: IndexPath)
    
}

protocol TriggersViewModelCoordinatorDelegate: class {

    
}

protocol TriggersViewModelViewDelegate: class {
    
    func updateDataSource(items: [String]?)
    func deleteRows(at indexPaths: [IndexPath])
}
