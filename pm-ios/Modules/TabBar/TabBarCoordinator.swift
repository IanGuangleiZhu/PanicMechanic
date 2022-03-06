//
//  TabBarCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/18/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

protocol TabBarCoordinatorDelegate: class {
    func didFinish(from coordinator: TabBarCoordinator)
}

class TabBarCoordinator: BaseCoordinator {
            
    // MARK: - Properties -
    weak var delegate: TabBarCoordinatorDelegate?
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
    
    override func start() {
        showTabBar()
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self)
    }
  
    private func showTabBar() {
        let homeNavController = UINavigationController()
        let historyNavController = UINavigationController()
        let profileNavController = UINavigationController()
        homeNavController.modalPresentationStyle = .fullScreen
        historyNavController.modalPresentationStyle = .fullScreen
        profileNavController.modalPresentationStyle = .fullScreen

        let homeCoordinator = HomeCoordinator(user: user, router: Router(rootController: homeNavController), apiClient: apiClient, localCache: localCache, localStore: localStore, cameraClient: cameraClient)
        let historyCoordinator = HistoryCoordinator(router: Router(rootController: historyNavController), apiClient: apiClient)
        let profileCoordinator = ProfileCoordinator(router: Router(rootController: profileNavController), apiClient: apiClient, localCache: localCache, cameraClient: cameraClient)

        let presentables: [Presentable] = [homeCoordinator, historyCoordinator, profileCoordinator]
        let viewModel = TabBarViewModel()
        viewModel.coordinatorDelegate = self
        let controller = TabBarController(presentables: presentables)
        controller.viewModel = viewModel
        addDependency(homeCoordinator)
        addDependency(historyCoordinator)
        addDependency(profileCoordinator)
        homeCoordinator.start()
        historyCoordinator.start()
        profileCoordinator.start()
        router.setRootModule(controller, hideBar: true)
    }
    
}

extension TabBarCoordinator: TabBarViewModelCoordinatorDelegate {
    
}

extension TabBarCoordinator: ProfileCoordinatorDelegate {
    
    func didFinish(from coordinator: ProfileCoordinator) {
        // End the current flow
        finish()
    }
    
}
