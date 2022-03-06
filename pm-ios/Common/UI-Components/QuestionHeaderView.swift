//
//  QuestionHeaderView.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/11/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class QuestionHeaderView: UITableViewHeaderFooterView {
    
    static var standardHeight: Double {
        return 40.0
    }
    
    static var reuseIdentifier: String {
        return "question.header"
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
        return label
    }()
    
    func configure(with viewModel: QuestionHeaderViewModel?) {
        titleLabel.text = viewModel?.title
    }
    
    func configure(with header: QuestionHeader?) {
        titleLabel.text = header?.titleText
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor(red:0.67, green:0.33, blue:0.55, alpha:1.0)
        contentView.addSubview(titleLabel)
        constrainSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func constrainSubviews() {
        constrain(titleLabel) { view in
            view.leading == view.superview!.leading + 16.0
            view.top == view.superview!.top + 8.0
            view.trailing == view.superview!.trailing - 16.0
            view.bottom == view.superview!.bottom - 8.0
        }
    }
    
}

struct QuestionHeader {
    
    let titleText: String

    init(title: String) {
        self.titleText = title
    }
    
}

extension QuestionHeader : QuestionHeaderViewModel {
    var title: String {
        return titleText
    }
}

extension QuestionHeader : TableViewItemViewModel {
    
    var height: Double {
        return QuestionHeaderView.standardHeight
    }
    var reuseIdentifier: String {
        return QuestionHeaderView.reuseIdentifier
    }
    
    var action: (() -> Void)? {
        return nil
    }
    
}

protocol QuestionHeaderViewModel {
    var title: String { get }
}
