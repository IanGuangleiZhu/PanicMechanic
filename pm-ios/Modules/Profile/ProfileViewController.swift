//
//  ProfileViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import FirebaseFirestore
import CoreLocation

class ProfileViewController: TableController {
    
    // MARK: - Properties -
    var viewModel: ProfileViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    // MARK: - Private Helpers -
    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "My Progress"
        tableView.allowsSelection = false
    }
        
    private func renderNavigationBarButtonItems() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        settingsButton.tintColor = Colors.panicRed
        self.navigationItem.setRightBarButton(settingsButton, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = Colors.panicRed
        } else {
            cell.backgroundColor = Colors.bgColor
        }
    }
    
}

// MARK: - Actions -
extension ProfileViewController {
    
    @objc func didTapSettingsButton(_ sender: UIBarButtonItem) {
        viewModel?.chooseSettings()
    }
    
}

// MARK: - View Delegate -
extension ProfileViewController: ProfileViewModelViewDelegate {
    
    func updateDataSource(ds: [TableViewSectionMap]) {
        self.datasource = ds
    }
    
}
