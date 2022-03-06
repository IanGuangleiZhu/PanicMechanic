//
//  AuthSplashViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Repeat
import Purchases

class AuthSplashViewModel: NSObject {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: AuthSplashViewModelCoordinatorDelegate?
    weak var viewDelegate: AuthSplashViewModelViewDelegate?
    
    // MARK: - Dependencies
    private let signInService: SignInService
    private let signOutService: SignOutService
    private let signUpService: SignUpService
    private let localCache: LocalCache
    private let deepLink: DeepLink?
    
    // MARK: - Properties
    private var timer: Repeater?
    
    // MARK: - Lifecycle
    init(signInService: SignInService, signOutService: SignOutService, signUpService: SignUpService, localCache: LocalCache, deepLink: DeepLink?) {
        self.signInService = signInService
        self.signOutService = signOutService
        self.signUpService = signUpService
        self.localCache = localCache
        self.deepLink = deepLink
    }
    
    deinit {
        log.verbose("Deallocing \(self)")
    }
    
}

// MARK: - Model Type
extension AuthSplashViewModel: AuthSplashViewModelType {
    
    func start() {
        viewDelegate?.startAnimating()
        timer = Repeater.once(after: .seconds(3)) { timer in
            if let _ = self.deepLink {
                self.performSelector(inBackground: #selector(self.getAndVerifyUser), with: nil)
            } else {
                self.performSelector(inBackground: #selector(self.getUser), with: nil)
            }
        }
    }
    
}

// MARK: - Private Helpers
extension AuthSplashViewModel {
    
    private func routeAuthorizedUser(user: AuthenticatedUser) {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                // User is "premium"
                if self.localCache.isTutorialComplete {
                    log.info("User has already completed initial tutorial.")
                    self.coordinatorDelegate?.proceedToMain(user: user)
                } else {
                    log.info("User has not completed initial tutorial.")
                    self.coordinatorDelegate?.proceedToTutorial(user: user)
                }
            } else {
                self.coordinatorDelegate?.proceedToPurchase()
            }
        }
    }
    
    @objc private func getUser() {
        signInService.getUser { user in
            if let user = user, user.verified {
                log.info("User is authorized and verified.")
                self.routeAuthorizedUser(user: user)
            } else {
                log.warning("User is not authorized or not verified.")
                self.coordinatorDelegate?.proceedToAuth()
            }
        }
    }
    
    @objc private func getAndVerifyUser() {
        signInService.getUser { user in
            if let user = user {
                if user.verified {
                    log.info("User is already authorized and verified.")
                    self.routeAuthorizedUser(user: user)
                } else {
                    log.warning("User is authorized but not verified.")
                    if let deepLink = self.deepLink, let oobCode = self.getOobCode(deepLink: deepLink) {
                        self.apply(code: oobCode)
                    } else {
                        log.error("Unable to parse deeplink URL.", context: self.deepLink?.dynamicLink.url)
                        self.signOut()
                    }
                }
            } else {
                log.warning("User is not authorized.")
                self.coordinatorDelegate?.proceedToAuth()
            }
        }
    }
    
    private func getOobCode(deepLink: DeepLink) -> String? {
        guard let url = deepLink.dynamicLink.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return nil }
        if let oobCodeQI = queryItems.filter({ $0.name == "oobCode" }).first, let oobCode = oobCodeQI.value {
            return oobCode
        }
        return nil
    }
    
    private func signOut() {
        signOutService.signOut { error in
            if let error = error {
                log.error("Error signing out. Forcing user to reauthenticate anyway.", context: error)
                self.coordinatorDelegate?.proceedToAuth()
                return
            }
        }
    }
    
    private func apply(code: String) {
        log.info("Applying Code:", context: code)
        signUpService.applyVerificationCode(code: code) { error in
            if let error = error {
                log.error("Error applying verification code.", context: error)
                self.signOut()
                return
            }
            log.info("Successfully applied verification code.")
            self.reload()
        }
    }
    
    private func reload() {
        signUpService.reloadUser { error in
            if let error = error {
                log.error("Error reloading user.", context: error)
                self.signOut()
                return
            }
            log.info("Successfully reloaded user.")
            self.getUser()
        }
    }
    
}
