//
//  PurchaseInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 6/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

// MARK: - Model Type
protocol PurchaseViewModelType {

    var viewDelegate: PurchaseViewModelViewDelegate? { get set }
    var coordinatorDelegate: PurchaseViewModelCoordinatorDelegate? { get set }

    func start()
    func restorePurchases()
    func handlePromo(code: String)
}

// MARK: - Coordinator Delegate
protocol PurchaseViewModelCoordinatorDelegate: class {

    func proceedFromPurchases()

}

// MARK: - View Delegate
protocol PurchaseViewModelViewDelegate: class {
    func updateDataSource(ds: [TableViewSectionMap])
    func showPurchaseFailedAlert(message: String)
    func showPromoFailedAlert()
}
