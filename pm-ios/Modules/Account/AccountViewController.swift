//
//  AccountViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

class AccountViewController: TableController {
    
    // MARK: - Properties -
    var viewModel: AccountViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private var deleteTextField: UITextField?
    private var proceedAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    private func setup() {
        proceedAction = UIAlertAction(title: "Proceed", style: .destructive) { action in
            self.viewModel?.deleteAccount()
        }
        proceedAction?.isEnabled = false
    }
}

// MARK: - Actions -
extension AccountViewController {
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        if let text = field.text, !text.isEmpty, text.lowercased() == "delete" {
            proceedAction?.isEnabled = true
        } else {
            proceedAction?.isEnabled = false
        }
    }
    
}

// MARK: - View Delegate -
extension AccountViewController: AccountViewModelViewDelegate {
    
    func updateDataSource(item: String?) {
        guard let item = item else { return }
        let section1 = TableViewSectionMap(section: nil, items: [
            BaseCell(title: "Email", detail: item, onPressed: nil)
        ], footer: nil)
        let section2 = TableViewSectionMap(section: nil, items: [
            DestructiveCell(title: "Delete Account") {
                self.showDeleteAccountAlert()
            }
        ], footer: nil)
        DispatchQueue.main.async {
            self.datasource = [section1, section2]
        }
    }
    
    func showDeleteAccountAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: "Delete Account", message: "Please type \"delete\" to confirm account removal. Your data will be removed forever.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                self.deleteTextField = textField
                self.deleteTextField?.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            if let proceedAction = self.proceedAction {
                alertController.addAction(proceedAction)
            }
            alertController.preferredAction = self.proceedAction
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: "Delete Account Failed", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let reauthAction = UIAlertAction(title: "Reauthenticate", style: .default) { action in
                self.viewModel?.reauthenticate()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(reauthAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
