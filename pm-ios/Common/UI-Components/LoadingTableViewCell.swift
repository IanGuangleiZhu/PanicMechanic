//
//  LoadingTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 11/4/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class LoadingTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 300.0
    }
    
    static var reuseIdentifier: String {
        return "loading.cell"
    }
    
    func configure(with viewModel: LoadingTableViewCellViewModel?) {
        textLabel?.text = viewModel?.loadingMessage
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
        backgroundColor = Colors.opaquePink
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
    
}

struct LoadingCell {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

extension LoadingCell : LoadingTableViewCellViewModel {
    
    var loadingMessage: String {
        return title
    }
    
}

extension LoadingCell : TableViewItemViewModel {
    
    var height: Double {
        return LoadingTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return LoadingTableViewCell.reuseIdentifier
    }
    
    var action: (() -> Void)? {
        return nil
    }
    
}

protocol LoadingTableViewCellViewModel {
    var loadingMessage: String { get }
}

