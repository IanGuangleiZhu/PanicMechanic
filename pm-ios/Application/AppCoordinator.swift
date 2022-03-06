//
//  AppCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    private let window: UIWindow?
    private lazy var rootViewController: UINavigationController = {
        let nav = UINavigationController()
        nav.modalPresentationStyle = .fullScreen
        return nav
    }()
    private lazy var router: Routable = Router(rootController: self.rootViewController)
    private lazy var apiClient: APIClient = {
        let env = Environment().configuration(PlistKey.env)
        let client = FirebaseClient()
        client.configure(env: env)
        return client
    }()
    private lazy var localCache: LocalCache = {
        let client = UserDefaultsClient()
        return client
    }()
    private lazy var localStore: LocalStore = {
        let store = CoreDataClient()
        return store
    }()
    private lazy var cameraClient: CameraClient = {
        let client = DefaultVideoClient(frameRate: 30)
        return client
    }()

    // MARK: - Lifecycle
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - BaseCoordinator
    override func start() {
        // Set up app window
        guard let window = window else {
            return
        }
        window.rootViewController = rootViewController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        showSplashView(deepLink: nil)
    }
    
    override func start(deepLink: DeepLink) {
        showSplashView(deepLink: deepLink)
    }

}

// MARK: - Coordinator Delegates
extension AppCoordinator: AuthCoordinatorDelegate {}
extension AppCoordinator: TabBarCoordinatorDelegate {}
extension AppCoordinator: TutorialCoordinatorDelegate {}
extension AppCoordinator: PurchaseCoordinatorDelegate {}
extension AppCoordinator: AuthSplashViewModelCoordinatorDelegate {
    
    func proceedToMain(user: AuthenticatedUser) {
        DispatchQueue.main.async {
            self.runMainFlow(with: user)
        }
    }
    
    func proceedToAuth() {
        DispatchQueue.main.async {
            self.runAuthFlow()
        }
    }
    
    func proceedToTutorial(user: AuthenticatedUser) {
        DispatchQueue.main.async {
            self.runTutorialFlow(with: user)
        }
    }
    
    func proceedToPurchase() {
        DispatchQueue.main.async {
            self.runPurchaseFlow()
        }
    }

    func didFinish(from coordinator: AuthCoordinator) {
        log.verbose("Finished running auth coordinator.")
        removeDependency(coordinator)
    }
 
    func didFinish(from coordinator: TabBarCoordinator) {
        log.verbose("Finished running tab bar coordinator.")
        removeDependency(coordinator)
    }
  
    func didFinish(from coordinator: TutorialCoordinator, with user: AuthenticatedUser?) {
        log.verbose("Finished running tutorial coordinator.")
        if let user = user {
            runMainFlow(with: user)
            removeDependency(coordinator)
        }
    }
    
    func didFinish(from coordinator: PurchaseCoordinator) {
        log.verbose("Finished running purchase coordinator.")
        removeDependency(coordinator)
        showSplashView(deepLink: nil)
    }

}

// MARK: - Private Helpers
extension AppCoordinator {
    
    private func showSplashView(deepLink: DeepLink?) {
        let signInService = SignInAPIService(apiClient: apiClient)
        let signOutService = SignOutAPIService(apiClient: apiClient)
        let signUpService = SignUpAPIService(apiClient: apiClient)
        let viewModel = AuthSplashViewModel(signInService: signInService, signOutService: signOutService, signUpService: signUpService, localCache: localCache, deepLink: deepLink)
        viewModel.coordinatorDelegate = self
        let controller = AuthSplashViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: true)
    }

    private func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router, apiClient: apiClient, localStore: localStore)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow(with user: AuthenticatedUser) {
        let coordinator = TabBarCoordinator(user: user, router: router, apiClient: apiClient, localCache: localCache, localStore: localStore, cameraClient: cameraClient)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runTutorialFlow(with user: AuthenticatedUser) {
        let coordinator = TutorialCoordinator(user: user, router: router, apiClient: apiClient, localCache: localCache, cameraClient: cameraClient, isAbridged: false)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runPurchaseFlow() {
        let coordinator = PurchaseCoordinator(router: router)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
    }
    
}
