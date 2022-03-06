//
//  TutorialCompleteInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol TutorialCompleteViewModelType {
    
    var viewDelegate: TutorialCompleteViewModelViewDelegate? { get set }
    var coordinatorDelegate: TutorialCompleteViewModelCoordinatorDelegate? { get set }

    func start()
    
    func skip()

    
}

protocol TutorialCompleteViewModelCoordinatorDelegate: class {
    
    func proceedFromComplete()
    

}

protocol TutorialCompleteViewModelViewDelegate: class {

    
}
