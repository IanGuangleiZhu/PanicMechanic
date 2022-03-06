//
//  BaseTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class BaseTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 64.0
    }
    
    static var reuseIdentifier: String {
        return "base.cell"
    }
    
    func configure(with viewModel: BaseTableViewCellViewModel?) {
        textLabel?.text = viewModel?.titleText
        detailTextLabel?.text = viewModel?.detailText
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {}
    
}

struct BaseCell {
    
    let title: String
    let detail: String?
    let onPressed: (() -> Void)?
    
    init(title: String, detail: String?, onPressed: (() -> Void)?) {
        self.title = title
        self.detail = detail
        self.onPressed = onPressed
    }
    
}

extension BaseCell: BaseTableViewCellViewModel {
    var titleText: String {
        return title
    }
    var detailText: String? {
        return detail
    }
}

extension BaseCell: TableViewItemViewModel {
    
    var height: Double {
        return BaseTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return BaseTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return onPressed }
    
}

protocol BaseTableViewCellViewModel {
    var titleText: String { get }
    var detailText: String? { get }
}


