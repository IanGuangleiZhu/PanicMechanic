//
//  PurchaseViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 6/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class PurchaseViewController: TableController {

    // MARK: - Properties
    var viewModel: PurchaseViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    private var triggerTextField : UITextField?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
  
    private func setup() {
        title = "Choose a Plan"
        view.backgroundColor = Colors.bgColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(didTapRestoreButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Promo", style: .plain, target: self, action: #selector(didTapPromoButton))
    }

}

// MARK: - Actions -
extension PurchaseViewController {
    @objc private func didTapRestoreButton(_ sender: UIBarButtonItem) {
        viewModel?.restorePurchases()
    }
    
    @objc private func didTapPromoButton(_ sender: UIBarButtonItem) {
        showEnterPromoDialog()
    }
}


// MARK: - View Delegate -
extension PurchaseViewController: PurchaseViewModelViewDelegate {
    
    func updateDataSource(ds: [TableViewSectionMap]) {
        self.datasource = ds
    }
    
    func showPurchaseFailedAlert(message: String) {
        let alert = UIView.basicAlert(title: "Purchase Failed", message: message, actionTitle: "OK")
        self.present(alert, animated: true)
    }
    
    func showPromoFailedAlert() {
        let alert = UIView.basicAlert(title: "Enter Promo Failed", message: "Failed to validate promo code.", actionTitle: "OK")
        self.present(alert, animated: true)
    }
    
    func showEnterPromoDialog() {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: "Enter Promo Code", message: "If you have been provided a promo code, please enter it below.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                self.triggerTextField = textField
                self.triggerTextField?.placeholder = "Promo Code"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            let saveAction = UIAlertAction(title: "Submit", style: .default) { _ in
                if let tf = alertController.textFields?[0], let code = tf.text {
                    self.viewModel?.handlePromo(code: code)
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            alertController.preferredAction = saveAction
            self.present(alertController, animated: true)
        }
    }
    
}
