//
//  PurchaseViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 6/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Purchases

class PurchaseViewModel {
    
    // MARK: - Properties
    weak var coordinatorDelegate: PurchaseViewModelCoordinatorDelegate?
    weak var viewDelegate: PurchaseViewModelViewDelegate?
    
}

// MARK: - Model Type
extension PurchaseViewModel: PurchaseViewModelType {
    
    func start() {
        createDataSource()
    }
    
    private func createDataSource() {
        var section: [TableViewItemViewModel] = []
        Purchases.shared.offerings { offerings, error in
            if let packages = offerings?.current?.availablePackages {
                for p in packages {
                    let cell = BaseCell(title: "\(p.product.localizedTitle) ($\(p.product.price)) + 7 Day Trial", detail: nil) {
                        self.purchase(package: p)
                    }
                    section.append(cell)
                }
            }
        }
        let ds: [TableViewSectionMap] = [
            TableViewSectionMap(section: nil, items: section, footer: nil)
        ]
        viewDelegate?.updateDataSource(ds: ds)
    }
    
    func restorePurchases() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let error = error {
                self.viewDelegate?.showPurchaseFailedAlert(message: error.localizedDescription)
                return
            }
            //... check purchaserInfo to see if entitlement is now active
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                // User is "premium"
                DispatchQueue.main.async {
                    self.coordinatorDelegate?.proceedFromPurchases()
                }
            } else {
                self.viewDelegate?.showPurchaseFailedAlert(message: "Purchases failed to restore.")
            }
        }
    }
    
    private func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
            if let error = error {
                self.viewDelegate?.showPurchaseFailedAlert(message: error.localizedDescription)
                return
            }
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                // Unlock that great "pro" content
                DispatchQueue.main.async {
                    self.coordinatorDelegate?.proceedFromPurchases()
                }
            } else {
                self.viewDelegate?.showPurchaseFailedAlert(message: "Failed to complete purchase.")
            }
        }
    }
    
    func handlePromo(code: String) {
        if code == "" || code.count == 0 {
            return
        }
        Purchases.shared.offerings { offerings, error in
            if let packages = offerings?.current?.availablePackages, let monthly = packages.filter({ $0.identifier == "$rc_monthly" }).first {
                let product = monthly.product
                if let yearlyPromo = product.discounts.first(where: { $0.identifier == code }) {
                    Purchases.shared.paymentDiscount(for: yearlyPromo, product: product, completion: { (paymentDiscount, err) in
                        guard let discount = paymentDiscount else {
                            DispatchQueue.main.async {
                                self.viewDelegate?.showPromoFailedAlert()
                            }
                            return
                        }
                        Purchases.shared.purchaseProduct(product, discount: discount) { transaction, info, error, cancelled in
                            if let _ = error {
                                DispatchQueue.main.async {
                                   self.viewDelegate?.showPromoFailedAlert()
                               }
                                return
                            }
                            if info?.entitlements.all["pro"]?.isActive == true {
                                // Unlock that great "pro" content
                                DispatchQueue.main.async {
                                    self.coordinatorDelegate?.proceedFromPurchases()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.viewDelegate?.showPromoFailedAlert()
                                }
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.viewDelegate?.showPromoFailedAlert()
                    }
                }
            }
        }
    }
    
}
