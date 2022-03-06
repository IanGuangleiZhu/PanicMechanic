//
//  TriggersViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/25/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

class TriggersViewController: TableController {
    
    // MARK: - Properties -
    var viewModel: TriggersViewModelType? {
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
    private func renderNavigationBarButtonItems() {
        if let shouldShowEditButton = viewModel?.shouldShowEditButton, shouldShowEditButton {
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
            navigationItem.setRightBarButton(editButton, animated: false)
        }
    }
    
    private func setup() {
        title = "Custom Triggers"
        view.backgroundColor = Colors.bgColor
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let trigger = viewModel?.item(at: indexPath.row) {
                showRemoveTriggerAlert(trigger: trigger, at: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let sections = super.numberOfSections(in: tableView)
        if sections == 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Custom Triggers"
            noDataLabel.textColor     = .lightGray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return sections
    }
    
}

// MARK: - Actions -
extension TriggersViewController {
    
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.title = !tableView.isEditing ? "Done" : "Edit"
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}

// MARK: - View Delegate -
extension TriggersViewController: TriggersViewModelViewDelegate {
    
    func deleteRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    func updateDataSource(items: [String]?) {
        guard let items = items, items.count > 0 else { return }
        let viewItems = items.map { BaseCell(title: $0, detail: nil, onPressed: nil)}
        DispatchQueue.main.async {
            self.datasource = [TableViewSectionMap(section: nil, items: viewItems, footer: nil)]
        }
    }
    
    func showRemoveTriggerAlert(trigger: String, at indexPath: IndexPath) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Confirm", message: "You are about to remove your custom trigger \"\(trigger)\"", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Proceed", style: .destructive, handler: { action in
                self.viewModel?.removeTrigger(at: indexPath)
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
}
