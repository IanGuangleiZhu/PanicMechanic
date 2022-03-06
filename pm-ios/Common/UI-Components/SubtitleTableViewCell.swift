//
//  SubtitleTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    static var standardHeight: Double {
        return 90.0
    }
    
    static var reuseIdentifier: String {
        return "subtitle.cell"
    }
    
    func configure(with viewModel: SubtitleTableViewCellViewModel?) {
        textLabel?.text = viewModel?.infoMessage
        detailTextLabel?.text = viewModel?.infoDetail
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = Colors.panicRed
    }
}

struct SubtitleCell {
    
    let title: String
    let detail: String?
    let onPressed: (() -> Void)?
    
    init(title: String, detail: String?, onPressed: (() -> Void)?) {
        self.title = title
        self.detail = detail
        self.onPressed = onPressed
    }
    
}

extension SubtitleCell : SubtitleTableViewCellViewModel {
    var infoMessage: String {
        return title
    }
    
    var infoDetail: String? {
        return detail
    }
}

extension SubtitleCell : TableViewItemViewModel {
    
    var height: Double {
        return SubtitleTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return SubtitleTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol SubtitleTableViewCellViewModel {
    var infoMessage: String { get }
    var infoDetail: String? { get }
}

