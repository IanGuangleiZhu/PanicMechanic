//
//  DestructiveTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class DestructiveTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 64.0
    }
    
    static var reuseIdentifier: String {
        return "destructive.cell"
    }
    
    func configure(with viewModel: DestructiveTableViewCellViewModel?) {
        textLabel?.text = viewModel?.titleText
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        textLabel?.textAlignment = .center
        textLabel?.textColor = .red
    }

}

struct DestructiveCell {
    
    let title: String
    let onPressed: (() -> Void)?
    
    init(title: String, onPressed: (() -> Void)?) {
        self.title = title
        self.onPressed = onPressed
    }
    
}

extension DestructiveCell : DestructiveTableViewCellViewModel {
    var titleText: String {
        return title
    }
}

extension DestructiveCell : TableViewItemViewModel {
    
    var height: Double {
        return DestructiveTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return DestructiveTableViewCell.reuseIdentifier
    }
    
    var action: (() -> Void)? {
        return onPressed
    }
    
}

protocol DestructiveTableViewCellViewModel {
    var titleText: String { get }
}
