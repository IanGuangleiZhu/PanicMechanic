//
//  RegisterCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

protocol RegisterCoordinatorDelegate: class {
    func didFinish(from coordinator: RegisterCoordinator)
}

class RegisterCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    weak var delegate: RegisterCoordinatorDelegate?
    let router: Routable
    let apiClient: APIClient
    let localStore: LocalStore

    init(router: Routable, apiClient: APIClient, localStore: LocalStore) {
        self.router = router
        self.apiClient = apiClient
        self.localStore = localStore
    }
    
    // MARK: - BaseCoordinator
    override func start() {
        showAcceptView()
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self)
    }

}

// MARK: - Coordinator Delegates
extension RegisterCoordinator: RegisterAcceptViewModelCoordinatorDelegate {}
extension RegisterCoordinator: RegisterDemographicViewModelCoordinatorDelegate {}
extension RegisterCoordinator: RegisterAccountViewModelCoordinatorDelegate {}
extension RegisterCoordinator: RegisterVerifyViewModelCoordinatorDelegate {}
extension RegisterCoordinator {
    
    func proceedFromAccept(with user: UnregisteredUser) {
        showDemographicView(with: user)
    }
    
    func proceedFromDemographics(with user: UnregisteredUser) {
        showAccountView(with: user)
    }
    
    func didCancelVerification() {
    }
    
    func didCompleteVerification() {
        finish()
    }
    
}

// MARK: - Private Helpers
extension RegisterCoordinator {
    
    private func showAcceptView() {
        let viewModel = RegisterAcceptViewModel(isRegister: true)
        viewModel.coordinatorDelegate = self
        let controller = RegisterAcceptViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func showDemographicView(with user: UnregisteredUser) {
        let viewModel = RegisterDemographicViewModel(user: user)
        viewModel.coordinatorDelegate = self
        let controller = RegisterDemographicViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func showAccountView(with user: UnregisteredUser) {
        let signUpService = SignUpAPIService(apiClient: apiClient)
        let userService = UserAPIService(apiClient: apiClient)
        let headlessUserService = HeadlessUserAPIService(localStore: localStore)
        let viewModel = RegisterAccountViewModel(signUpService: signUpService, userService: userService, user: user, headlessUserService: headlessUserService)
        viewModel.coordinatorDelegate = self
        let controller = RegisterAccountViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func showVerifyView(user: AuthenticatedUser, deepLink: DeepLink?) {
        let signUpService = SignUpAPIService(apiClient: apiClient)
        let signOutService = SignOutAPIService(apiClient: apiClient)
        let headlessUserService = HeadlessUserAPIService(localStore: localStore)
        let userService = UserAPIService(apiClient: apiClient)
        let viewModel = RegisterVerifyViewModel(signUpService: signUpService, signOutService: signOutService, headlessUserService: headlessUserService, userService: userService, user: user, deepLink: deepLink)
        viewModel.coordinatorDelegate = self
        let controller = RegisterVerifyViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
}
