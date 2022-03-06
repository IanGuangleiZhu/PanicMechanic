//
//  PurchaseCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 6/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

protocol PurchaseCoordinatorDelegate: class {
    func didFinish(from coordinator: PurchaseCoordinator)
}

class PurchaseCoordinator: BaseCoordinator {
    
    // MARK: - Delegates
    weak var delegate: PurchaseCoordinatorDelegate?
    
    // MARK: - Dependencies
    private let router: Routable

    // MARK: - Lifecycle
    init(router: Routable) {
        self.router = router
    }

    // MARK: - BaseCoordinator
    override func start() {
        showPurchaseView()
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self)
    }
    
    // MARK: - Private Helpers
    private func showPurchaseView() {
        let viewModel = PurchaseViewModel()
        viewModel.coordinatorDelegate = self
        let controller = PurchaseViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }


}

extension PurchaseCoordinator: PurchaseViewModelCoordinatorDelegate {

    func proceedFromPurchases() {
        finish()
    }

}
