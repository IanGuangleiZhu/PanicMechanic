//
//  AuthCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//
import UIKit

protocol AuthCoordinatorDelegate: class {
    func didFinish(from coordinator: AuthCoordinator)
}

class AuthCoordinator: BaseCoordinator {
    
    // MARK: - Delegates
    weak var delegate: AuthCoordinatorDelegate?

    // MARK: - Dependencies
    private let router: Routable
    private let apiClient: APIClient
    private let localStore: LocalStore

    // MARK: - Lifecycle
    init(router: Routable, apiClient: APIClient, localStore: LocalStore) {
        self.router = router
        self.apiClient = apiClient
        self.localStore = localStore
    }
    
    // MARK: - BaseCoordinator
    override func start() {
        apiClient.getUser { user in
            if let user = user {
                // Authorized but not verified
                self.showVerifyView(user: user, deepLink: nil)
            } else {
                // Not authorized
                self.showOnboardView()
            }
        }
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self)
    }
    
    // MARK: - Private Helpers -
    private func showOnboardView() {
        let viewModel = AuthOnboardViewModel()
        viewModel.coordinatorDelegate = self
        let controller = AuthOnboardViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
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
        router.setRootModule(controller, hideBar: true)
    }
    
    private func showLoginView() {
        let signInService = SignInAPIService(apiClient: apiClient)
        let viewModel = AuthLoginViewModel(signInService: signInService)
        viewModel.coordinatorDelegate = self
        let controller = AuthLoginViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func runRegisterFlow() {
        let coordinator = RegisterCoordinator(router: router, apiClient: apiClient, localStore: localStore)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func pushResetView() {
        let passwordService = PasswordAPIService(apiClient: apiClient)
        let viewModel = AuthResetViewModel(passwordService: passwordService)
        viewModel.coordinatorDelegate = self
        let controller = AuthResetViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
}

// MARK: - Coordinator Delegates -
extension AuthCoordinator: AuthOnboardViewModelCoordinatorDelegate {}
extension AuthCoordinator: RegisterCoordinatorDelegate {}
extension AuthCoordinator: AuthLoginViewModelCoordinatorDelegate {}
extension AuthCoordinator: RegisterVerifyViewModelCoordinatorDelegate {}
extension AuthCoordinator: AuthResetViewModelCoordinatorDelegate {}
extension AuthCoordinator {
    
    func didLogIn() {
//        finish()
    }
    
    func presentVerification(with user: AuthenticatedUser) {
        showVerifyView(user: user, deepLink: nil)
    }
    
    func didCancelVerification() {
//        finish()
    }
    
    func didCompleteVerification() {
        finish()
    }

    func didChooseLogIn() {
        showLoginView()
    }
    
    func didChooseRegister() {
        runRegisterFlow()
    }
    
    func didForgetPassword() {
        // Show recover password flow
        pushResetView()
    }
    
    func didFinish(from coordinator: RegisterCoordinator) {
        // End the current flow
        finish()
    }

    func proceedFromReset() {
        
    }
    
    func didSubmitEmail(email: String) {
        // pop back to login
    }
    
    func proceedToOnboard() {
//        showOnboardView()
    }
    
}
