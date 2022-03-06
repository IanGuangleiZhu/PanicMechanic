//
//  HomeInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/22/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol HomeViewModelType {
    
    var viewDelegate: HomeViewModelViewDelegate? { get set }
    var coordinatorDelegate: HomeViewModelCoordinatorDelegate? { get set }
    
    var shouldShowNextButton: Bool { get }

    func start()
    
    func togglePractice(isOn: Bool)
    func panic()
    func startTutorial()
    func stopTutorial()
}

protocol HomeViewModelCoordinatorDelegate: class {
    
    func proceedFromHome(with user: PanicMechanicUser?)

}

protocol HomeViewModelViewDelegate: class {
    
    func enablePanicButton()
    func disablePanicButton()
    
    func showCoachMarks()
    
    func hideCoachMarks()
    
}
