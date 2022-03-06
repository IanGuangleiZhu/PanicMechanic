//
//  InfoTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class InfoMessageTableViewCell: UITableViewCell {
    static var standardHeight: Double {
        return 44.0
    }
    
    static var reuseIdentifier: String {
        return "infoMessage.cell"
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12.0)
        label.textColor = Colors.panicRed
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = Colors.panicRed
        return label
    }()
    
    func configure(with viewModel: InfoMessageTableViewCellViewModel?) {
        messageLabel.text = viewModel?.infoMessage
        if let infoDetail = viewModel?.infoDetail {
            valueLabel.text = infoDetail
            accessoryType = .none
        } else {
            accessoryType = .disclosureIndicator
        }
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
        backgroundColor = Colors.bgColor
        contentView.addSubview(messageLabel)
        contentView.addSubview(valueLabel)
        constrain(messageLabel) { view in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.centerY == view.superview!.safeAreaLayoutGuide.centerY
        }
        constrain(valueLabel, messageLabel) { view, mL in
            view.leading == mL.trailing
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.centerY == view.superview!.safeAreaLayoutGuide.centerY
        }
    }
}
struct InfoCell {
    
    let title: String
    let detail: String?
    let onPressed: (() -> Void)?
    
    init(title: String, detail: String?, onPressed: (() -> Void)?) {
        self.title = title
        self.detail = detail
        self.onPressed = onPressed
    }
    
}

extension InfoCell : InfoMessageTableViewCellViewModel {
    var infoMessage: String {
        return title
    }
    
    var infoDetail: String? {
        return detail
    }
}

extension InfoCell : TableViewItemViewModel {
    
    var height: Double {
        return InfoMessageTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return InfoMessageTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return onPressed }
    
}

protocol InfoMessageTableViewCellViewModel {
    var infoMessage: String { get }
    var infoDetail: String? { get }
}
