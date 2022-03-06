//
//  ProfileCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//
import UIKit

protocol ProfileCoordinatorDelegate: class {
    func didFinish(from coordinator: ProfileCoordinator)
}

class ProfileCoordinator: BaseCoordinator {
    
    // MARK: - Properties -
    weak var delegate: ProfileCoordinatorDelegate?
    let router: Routable
    let apiClient: APIClient
    let localCache: LocalCache
    let cameraClient: CameraClient
    
    init(router: Routable, apiClient: APIClient, localCache: LocalCache, cameraClient: CameraClient) {
        self.router = router
        self.apiClient = apiClient
        self.localCache = localCache
        self.cameraClient = cameraClient
    }
    
    override func start() {
        showProfileView()
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self)
    }

    // MARK: - Private Helpers -
    
    private func showProfileView() {
        let episodeService = EpisodeAPIService(apiClient: apiClient)
        let userService = UserAPIService(apiClient: apiClient)
        let viewModel = ProfileViewModel(episodeService: episodeService, userService: userService)
        viewModel.coordinatorDelegate = self
        let controller = ProfileViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showSettingsView() {
        let signOutService = SignOutAPIService(apiClient: apiClient)
        let viewModel = SettingsViewModel(service: signOutService)
        viewModel.coordinatorDelegate = self
        let controller = SettingsViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func pushTermsView() {
        let viewModel = RegisterAcceptViewModel(isRegister: false)
//        viewModel.coordinatorDelegate = self
        let controller = RegisterAcceptViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func pushCalibrationView() {
        let fingerDetectService = FingerDetectAPIService(localCache: localCache)
        let viewModel = TutorialCalibrateViewModel(cameraClient: cameraClient, localCache: localCache, fingerDetectService: fingerDetectService, isTutorial: false)
        viewModel.coordinatorDelegate = self
        let controller = TutorialCalibrateViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func pushCustomTriggersView() {
        let userService = UserAPIService(apiClient: apiClient)
        let viewModel = TriggersViewModel(userService: userService, isSettings: true)
        viewModel.coordinatorDelegate = self
        let controller = TriggersViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func pushAccountView() {
        let viewModel = AccountViewModel(apiClient: apiClient)
        viewModel.coordinatorDelegate = self
        let controller = AccountViewController()
        controller.viewModel = viewModel
        router.push(controller, animated: true)
    }
    
    private func runTutorialFlow(with user: AuthenticatedUser?) {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        let subrouter = Router(rootController: navigationController)
        let coordinator = TutorialCoordinator(user: user, router: subrouter, apiClient: apiClient, localCache: localCache, cameraClient: cameraClient, isAbridged: true)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
        router.present(coordinator, animated: true)
    }
    
    private func showReauthenticationView() {
        let signInService = SignInAPIService(apiClient: apiClient)
        let viewModel = ReauthenticationViewModel(signInService: signInService)
        viewModel.coordinatorDelegate = self
        let controller = ReauthenticationViewController()
        controller.viewModel = viewModel
        router.present(controller, animated: true)
    }
    
}

extension ProfileCoordinator: Presentable {
    /**
        Allows passing of coordinator to a router.
     */
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }
    
}

extension ProfileCoordinator: ProfileViewModelCoordinatorDelegate {
    
    func didChooseSettings() {
        showSettingsView()
    }
    
}

extension ProfileCoordinator: SettingsViewModelCoordinatorDelegate {
    
    func didSignOut() {
        // End the current flow
        finish()
    }
    
    func didStartTutorial() {
        runTutorialFlow(with: nil)
    }
    
    func didChooseTerms() {
        pushTermsView()
    }
    
    func didChooseCalibration() {
        pushCalibrationView()
    }
    
    func didChooseCustomTriggers() {
        pushCustomTriggersView()
    }
    
    func didChooseAccount() {
        pushAccountView()
    }
    
}

extension ProfileCoordinator: TutorialCoordinatorDelegate {
    
    func didFinish(from coordinator: TutorialCoordinator, with user: AuthenticatedUser?) {
        router.dismissModule(animated: true) {
            self.removeDependency(coordinator)
        }
    }

}

extension ProfileCoordinator: TutorialRequirementsViewModelCoordinatorDelegate {
    func proceedFromRequirements() {
        
    }
    
    
    func proceedToCalibrate() {
    }
    
}

extension ProfileCoordinator: TutorialCalibrateViewModelCoordinatorDelegate {
    func proceedFromCalibrate() {
        router.popModule(animated: true)
    }
    
    func proceedToHome() {
        
    }
    
    
    func popModule() {
        router.popModule(animated: true)
    }
}

extension ProfileCoordinator: TriggersViewModelCoordinatorDelegate {}
extension ProfileCoordinator: AccountViewModelCoordinatorDelegate {
    func showReauthentication() {
        showReauthenticationView()
    }
    
    func didDeleteAccount() {
        log.info("Account successfully deleted.")
        finish()
    }
}
extension ProfileCoordinator: ReauthenticationViewModelCoordinatorDelegate {
    
    func didReauthenticate() {
        router.dismissModule(animated: true, completion: nil)
    }
    
    
}
