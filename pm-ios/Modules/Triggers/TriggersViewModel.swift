//
//  TriggersViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/25/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class TriggersViewModel: TriggersViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: TriggersViewModelCoordinatorDelegate?
    weak var viewDelegate: TriggersViewModelViewDelegate?
    
    // MARK: - Dependencies -
    private let userService: UserService
    private let isSettings: Bool
    
    // MARK: - Properties -
    var shouldShowEditButton: Bool {
        return isSettings
    }
    
    private var user: PanicMechanicUser?
    private var items: [String]? = [] {
        didSet {
            viewDelegate?.updateDataSource(items: items)
        }
    }
    
    // MARK: - Lifecycle -
    init(userService: UserService, isSettings: Bool) {
        self.userService = userService
        self.isSettings = isSettings
    }
    
    func start() {
        loadCustomTriggers()
    }
    
    func item(at index: Int) -> String? {
        return items?[index]
    }
    
    func removeTrigger(at indexPath: IndexPath) {
        guard let user = user else { return }
        if let items = items {
            var newTriggers = items
            newTriggers.remove(at: indexPath.row)
            userService.updateTriggers(user: user, triggers: newTriggers) { error in
                if let error = error {
                    log.error("Error occurred while updating triggers.", context: error)
                    return
                }
                log.info("Triggers updated successfully!")
//                self.viewDelegate?.deleteRows(at: [indexPath])
                self.items = newTriggers
            }
        }
    }
    
    private func loadCustomTriggers() {
        userService.loadUser { user, error in
            if let error = error {
                log.error("An error occurred while loading the user:", context: error)
                return
            }
            self.user = user
            self.items = user?.triggers.filter { $0 != "UNKNOWN" }
        }
    }

}


