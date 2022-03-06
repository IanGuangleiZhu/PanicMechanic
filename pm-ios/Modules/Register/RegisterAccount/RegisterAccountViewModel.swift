//
//  RegisterAccountViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class RegisterAccountViewModel: RegisterAccountViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: RegisterAccountViewModelCoordinatorDelegate?
    weak var viewDelegate: RegisterAccountViewModelViewDelegate?
        
    // MARK: - Dependencies -
    private let signUpService: SignUpService
    private let userService: UserService
    private var user: UnregisteredUser
    private let headlessUserService: HeadlessUserService

    init(signUpService: SignUpService, userService: UserService, user: UnregisteredUser, headlessUserService: HeadlessUserService) {
        self.signUpService = signUpService
        self.userService = userService
        self.user = user
        self.headlessUserService = headlessUserService
    }
    
    func start() {}
    
    func register(email: String, password: String) {
        viewDelegate?.showLoadingIndicator()
        signUpService.register(email: email, password: password) { error in
            if let error = error {
                self.viewDelegate?.hideLoadingIndicator()
                self.viewDelegate?.showError(message: error.localizedDescription)
                log.error("Registration failed:", context: error)
                return
            }
            log.info("Successfully registered account:", context: email)
            self.user.email = email
            self.sendEmailVerification()
        }
    }
    
    func sendEmailVerification() {
        signUpService.verify { error in
            if let error = error {
                self.viewDelegate?.hideLoadingIndicator()
                self.viewDelegate?.showError(message: error.localizedDescription)
                // TODO: add alert controller that allows resending
                log.error("Send verification failed, try again:", context: error)
                return
            }
            log.info("Successfully sent verification email.")
            self.cacheHeadlessUser()
        }
    }
    
    private func cacheHeadlessUser() {
        guard let age = user.age, let gender = user.gender else {
            #if DEBUG
                log.error("Failed to cache headless user, insufficent data:", context: [user])
            #endif
            return
        }
        #if DEBUG
            log.info("Caching headless user...")
        #endif
        headlessUserService.create(age: age, gender: gender.rawValue, nickname: self.user.nickname)
    }
    
//    private func addUser() {
//        guard let age = self.user.age, let gender = self.user.gender else { return }
//        userService.addUser(age: age, gender: gender.rawValue.uppercased(), nickname: self.user.nickname) { error in
//            self.viewDelegate?.hideLoadingIndicator()
//            if let error = error {
//                self.viewDelegate?.showError(message: error.localizedDescription)
//                log.error("Add user document failed:", context: error)
//                return
//            }
//            log.info("Successfully added new user document.")
//        }
//    }
    
}
