//
//  HistoryCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//
import UIKit

class HistoryCoordinator: BaseCoordinator {
    
    // MARK: - Properties -
    weak var delegate: AuthCoordinatorDelegate?
    let router: Routable
    let apiClient: APIClient
    
    init(router: Routable, apiClient: APIClient) {
        self.router = router
        self.apiClient = apiClient
    }
    
    override func start() {
        showHistoryView()
    }
    
    // MARK: - Private Helpers -
    private func showHistoryView() {
        let episodeService = EpisodeAPIService(apiClient: apiClient)
        let viewModel = HistoryViewModel(service: episodeService)
        viewModel.coordinatorDelegate = self
        let controller = HistoryViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
}

extension HistoryCoordinator: Presentable {
    /**
        Allows passing of coordinator to a router.
     */
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }
    
}

// MARK: - Coordinator Delegates -
extension HistoryCoordinator: HistoryViewModelCoordinatorDelegate {}
