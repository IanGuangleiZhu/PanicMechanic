//
//  SettingsViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/18/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class SettingsViewController: TableController {
    
    // MARK: - Properties -
    var viewModel: SettingsViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    private func setup() {
//        view.backgroundColor = UIColor(red:1.00, green:0.95, blue:0.98, alpha:1.0)
        view.backgroundColor = Colors.bgColor
    }
    
}

// MARK: - View Delegate -
extension SettingsViewController: SettingsViewModelViewDelegate {

    func updateDataSource(ds: [TableViewSectionMap]) {
        self.datasource = ds
    }
    
    func showSignOutAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Are you sure?", message: "You will need to reauthenticate to access your data.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Proceed", style: .destructive, handler: { action in
                self.viewModel?.signOut()
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func showTutorialAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Are you sure?", message: "You are about to initiate the tutorial.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Proceed", style: .destructive, handler: { action in
                self.viewModel?.startTutorial()
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
}
