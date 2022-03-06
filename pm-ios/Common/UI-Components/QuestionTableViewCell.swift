//
//  QuestionTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/11/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 44.0
    }
    
    static var reuseIdentifier: String {
        return "question.cell"
    }
    
    func configure(with viewModel: QuestionTableViewCellViewModel?) {
        textLabel?.text = viewModel?.title
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
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red:0.58, green:0.49, blue:0.87, alpha:1.0)
        textLabel?.textColor = Colors.lightPanicRed
        textLabel?.font = .boldSystemFont(ofSize: 16.0)
        textLabel?.highlightedTextColor = .white
        
        // These 3 lines allow font to be resized for long text
        textLabel?.numberOfLines = 1
        textLabel?.minimumScaleFactor = 0.7
        textLabel?.adjustsFontSizeToFitWidth = true
    }
    
}
struct QuestionCell {
    
    let titleText: String
    
    init(title: String) {
        self.titleText = title
    }
    
}

extension QuestionCell : QuestionTableViewCellViewModel {
    var title: String {
        return titleText
    }
}

extension QuestionCell : TableViewItemViewModel {
    
    var height: Double {
        return QuestionTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return QuestionTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? {
        return nil
    }
    
}

protocol QuestionTableViewCellViewModel {
    var title: String { get }
}
