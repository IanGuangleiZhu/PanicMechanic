//
//  ProfileInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol ProfileViewModelType {
    
    var viewDelegate: ProfileViewModelViewDelegate? { get set }
    var coordinatorDelegate: ProfileViewModelCoordinatorDelegate? { get set }

    func start()
    
    func chooseSettings()
}

protocol ProfileViewModelCoordinatorDelegate: class {
    
    func didChooseSettings()
    
}

protocol ProfileViewModelViewDelegate: class {

    func updateDataSource(ds: [TableViewSectionMap])

}
