//
//  RegisterVerifyInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol RegisterVerifyViewModelType {
    
    var viewDelegate: RegisterVerifyViewModelViewDelegate? { get set }
    var coordinatorDelegate: RegisterVerifyViewModelCoordinatorDelegate? { get set }

    func start()
    
    func resendLink()
    func checkVerificationStatus()
    func changePassword()
    func cancel()
}

protocol RegisterVerifyViewModelCoordinatorDelegate: class {
    
    func didCancelVerification()
    func didCompleteVerification()
    
}

protocol RegisterVerifyViewModelViewDelegate: class {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateTitleLabel(with email: String)
    func showAlertMessage(title: String, message: String)
}
