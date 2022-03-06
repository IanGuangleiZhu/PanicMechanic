//
//  HomeCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

class HomeCoordinator: BaseCoordinator, Presentable {
    
    // MARK: - Dependencies
    private let user: AuthenticatedUser
    let router: Routable
    let apiClient: APIClient
    let localCache: LocalCache
    let localStore: LocalStore
    let cameraClient: CameraClient
        
    init(user: AuthenticatedUser, router: Routable, apiClient: APIClient, localCache: LocalCache, localStore: LocalStore, cameraClient: CameraClient) {
        self.user = user
        self.router = router
        self.apiClient = apiClient
        self.localCache = localCache
        self.localStore = localStore
        self.cameraClient = cameraClient
    }
    
    // MARK: - BaseCoordinator
    override func start() {
        showHomeView(with: user)
    }
    
    
    // MARK: - Presentable
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }

}

// MARK: - Coordinator Delegates -
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {}
extension HomeCoordinator: RecordCoordinatorDelegate {}
extension HomeCoordinator {

    func proceedFromHome(with user: PanicMechanicUser?) {
        DispatchQueue.main.async {
            self.runRecordFlow(user: user)
        }
    }

    func didFinish(from coordinator: RecordCoordinator) {
        DispatchQueue.main.async {
            self.router.dismissModule(animated: true, completion: nil)
        }
    }
    
}

// MARK: - Private Helpers
extension HomeCoordinator {
    
    private func showHomeView(with user: AuthenticatedUser) {
        let userService = UserAPIService(apiClient: apiClient)
        let cycleService = CycleAPIService(localStore: localStore)
        let episodeLocationService = EpisodeLocationAPIService(localStore: localStore)
        let headlessUserService = HeadlessUserAPIService(localStore: localStore)
        let viewModel = HomeViewModel(user: user, localCache: localCache, userService: userService, cycleService: cycleService, episodeLocationService: episodeLocationService, headlessUserService: headlessUserService, isTutorial: false)
        viewModel.coordinatorDelegate = self
        let controller = HomeViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func runRecordFlow(user: PanicMechanicUser?) {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        let subrouter = Router(rootController: navigationController)
        let coordinator = RecordCoordinator(router: subrouter, apiClient: apiClient, localCache: localCache, localStore: localStore, cameraClient: cameraClient, user: user)
        coordinator.delegate = self
        addDependency(coordinator)
        coordinator.start()
        router.present(coordinator, animated: true)
    }
    
}
