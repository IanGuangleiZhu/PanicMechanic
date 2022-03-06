//
//  HistoryViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import FirebaseFirestore

class HistoryViewController: TableController {
    
    // MARK: - Properties -
    var viewModel: HistoryViewModelType? {
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
    
    // MARK: - Private Helpers -
    private func setup() {
        view.backgroundColor = Colors.bgColor
        navigationItem.title = "History"
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = super.tableView(tableView, viewForHeaderInSection: section) as? HistoryHeaderView
        headerView?.delegate = self
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        cell.backgroundColor = Colors.bgColor
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let sections = super.numberOfSections(in: tableView)
        if sections == 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Panic Attacks"
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

// MARK: - View Delegate -
extension HistoryViewController: HistoryViewModelViewDelegate {
    
    func updateDataSource(ds: [TableViewSectionMap]) {
        self.datasource = ds
    }
    
}

extension HistoryViewController: HistoryHeaderViewDelegate {
    
    func showContextMenu(section: Int) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        let alert = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
        
        let infoAction = UIAlertAction(title: "Additional Info", style: .default) { action in
            if let episode = self.viewModel?.item(at: section) {
                self.showAdditionalInfo(episode: episode)
            }
        }
        let deleteAction = UIAlertAction(title: "Remove Attack", style: .destructive) { action in
            print("Removing episode at: \(section)")
            if let episode = self.viewModel?.item(at: section) {
                self.showDeleteWarning(episode: episode)
            }
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        
        alert.addAction(infoAction)
        alert.addAction(deleteAction)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAdditionalInfo(episode: PanicMechanicEpisode) {
        let duration = episode.stopTs - episode.startTs
        let start = Date.timeFormatter.string(from: episode.startTs)
        let stop = Date.timeFormatter.string(from: episode.stopTs)
        let message = String(format: "Began: %@\nEnded: %@\nDuration: %.1f sec", start, stop, duration)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteWarning(episode: PanicMechanicEpisode) {
        let alert = UIAlertController(title: "Are you sure?", message: "You will not be able to recover this data.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Proceed", style: .destructive) { action in
            self.viewModel?.deleteEpisode(episode: episode)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)

    }
    
    
}
