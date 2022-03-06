//
//  RegisterVerifyViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat

class RegisterVerifyViewModel: RegisterVerifyViewModelType {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: RegisterVerifyViewModelCoordinatorDelegate?
    weak var viewDelegate: RegisterVerifyViewModelViewDelegate?
    
    // MARK: - Dependencies
    private let signUpService: SignUpService
    private let signOutService: SignOutService
    private let headlessUserService: HeadlessUserService
    private let userService: UserService
    private let deepLink: DeepLink?
    
    // MARK: - Properties
    private var user: AuthenticatedUser
    private var timer: Repeater?
    
    // MARK: - Lifecycle -
    init(signUpService: SignUpService, signOutService: SignOutService, headlessUserService: HeadlessUserService, userService: UserService, user: AuthenticatedUser, deepLink: DeepLink? = nil) {
        self.signUpService = signUpService
        self.signOutService = signOutService
        self.headlessUserService = headlessUserService
        self.userService = userService
        self.user = user
        self.deepLink = deepLink
    }
    
    func start() {
        headlessUserService.loadLatestHeadlessUser { user, error in
            if let error = error {
                #if DEBUG
                    log.error("error loading headless user:", context: error)
                #endif
                return
            }
            #if DEBUG
                log.info("Successfully loaded latest headless user.", context: [user])
            #endif
            if let user = user, let gender = user.gender {
                self.addUser(age: Int(user.age), gender: gender, nickname: user.nickname)
            }
        }
        viewDelegate?.updateTitleLabel(with: user.email)
    }
    
    
    func resendLink() {
        sendLink()
    }
    
    func checkVerificationStatus() {
        signUpService.isVerified { verified in
            log.warning("User verification status:", context: verified)
            if verified {
                self.coordinatorDelegate?.didCompleteVerification()
            }
        }
    }
    
    func changePassword() {
    }
    
    func cancel() {
        signOutService.signOut { error in
            if let error = error {
                log.error("An error occurred while signing out:", context: error)
                return
            }
            log.info("Signed out successfully!")
            // Force user back to onboard screen
            //            self.coordinatorDelegate?.didCancelVerification()
        }
    }
    
    private func sendLink() {
        signUpService.verify { error in
            if let error = error {
                // Show error message
                log.error("An error occurred while sending verification email:", context: error)
                self.viewDelegate?.showAlertMessage(title: "Warning", message: "A new link was recently sent to your email and should arrive soon. If it does not appear, please wait a few minutes and try again.")
            } else {
                // Show success resent
                log.info("Email sent successfully!")
                self.viewDelegate?.showAlertMessage(title: "Success", message: "A new link was sent to your email. It should appear in your inbox in the next 5 minutes.")
            }
        }
    }
    
    private func addUser(age: Int, gender: String, nickname: String?) {
        guard let userGender = UserGender(rawValue: gender) else { return }
        let stats = UserStats(recoveryDuration: 0, totalAttacks: 0)
        let pmu = PanicMechanicUser(uid: user.uid, age: age, gender: userGender, nickname: nickname, stats: stats, triggers: [])
        userService.addUser(user: pmu) { error in
            if let error = error {
                self.viewDelegate?.hideLoadingIndicator()
                //                self.viewDelegate?.showError(message: error.localizedDescription)
                log.error("Add user document failed:", context: error)
                return
            }
            log.info("Successfully added new user document.")
            //            self.sendEmailVerification()
            self.headlessUserService.deleteHeadlessUsers { error in
                if let error = error {
                    //                        self.viewDelegate?.hideLoadingIndicator()
                    //                self.viewDelegate?.showError(message: error.localizedDescription)
                    log.error("Delete headless users failed:", context: error)
                    return
                }
                log.info("Successfully removed headless users.")
            }
        }
    }
    
}
