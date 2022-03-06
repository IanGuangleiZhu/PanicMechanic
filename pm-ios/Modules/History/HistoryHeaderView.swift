//
//  HistoryHeaderView.swift
//  pm-ios
//
//  Created by Synbrix Software on 11/4/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

protocol HistoryHeaderViewDelegate: class {
    func showContextMenu(section: Int)
}

class HistoryHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HistoryHeaderViewDelegate?
    
    // MARK: - TableViewItem
    static var standardHeight: Double {
        return 72.0
    }
    
    static var reuseIdentifier: String {
        return "history.header"
    }
    
    // MARK: - UI Elements
    private let triggerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.bgColor
        label.textAlignment = .left
        label.text = "Financial Situation"
        label.numberOfLines = 1
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 22.0)
        return label
    }()
    
    private let dateLocationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "18 hours ago / New York, NY"
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 17.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let contextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Context"), for: .normal)
        button.tintColor = Colors.bgColor
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTapContextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        triggerLabel.text = nil
        dateLocationLabel.text = nil
    }
    
    func configure(with viewModel: HistoryHeaderViewModel?) {
        triggerLabel.text = viewModel?.triggerString
        dateLocationLabel.text = viewModel?.whenWhereString
    }
        
}

// MARK: - Layout
extension HistoryHeaderView {
    
    private func constrainSubviews() {
        constrain(contextButton) { view in
            view.centerY == view.superview!.centerY
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(triggerLabel, contextButton) { view, cB in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.top == view.superview!.safeAreaLayoutGuide.top + 12.0
            view.trailing == cB.leading
        }
        constrain(dateLocationLabel, triggerLabel, contextButton) { view, tL, cB in
            view.top == tL.bottom
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == cB.leading
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.lightPanicRed
        contentView.addSubview(triggerLabel)
        contentView.addSubview(dateLocationLabel)
        contentView.addSubview(contextButton)
        constrainSubviews()
    }
    
}

// MARK: - Actions
extension HistoryHeaderView {
    
    @objc private func didTapContextButton(_ sender: UIButton) {
        delegate?.showContextMenu(section: tag)
    }
    
}
