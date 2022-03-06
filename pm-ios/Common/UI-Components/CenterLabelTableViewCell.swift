//
//  CenterLabelTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/13/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class CenterLabelTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 72.0
    }
    
    static var reuseIdentifier: String {
        return "centerlabel.cell"
    }
    
    private let cardView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = Colors.bgColor
    //        view.elevate(elevation: 4)
    //        view.layer.cornerRadius = 10.0
    //        view.layer.masksToBounds = true
            return view
        }()
    
    private let plotTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plot Title"
        label.textColor = Colors.panicRed
        label.font = .boldSystemFont(ofSize: 16)

        return label
    }()
    
    private let centerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Center Label"
        label.textColor = Colors.panicRed
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center

        return label
    }()
   
    
    func configure(with viewModel: CenterLabelTableViewCellViewModel?) {
        self.plotTitleLabel.text = viewModel?.infoMessage
        self.centerLabel.text = viewModel?.detailMessage
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
        contentView.backgroundColor = .white
        contentView.addSubview(cardView)
        cardView.addSubview(plotTitleLabel)
        cardView.addSubview(centerLabel)
        constrain(cardView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.safeAreaLayoutGuide.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
        }
        constrain(plotTitleLabel) { view in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
        }
        constrain(centerLabel, plotTitleLabel) { view, pTL in
            view.leading == pTL.leading
            view.trailing == pTL.trailing
            view.top == pTL.bottom
        }
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        plotTitleLabel.text = nil
        centerLabel.text = nil
    }
    
}

struct CenterLabelCell {
    
    let title: String
    let detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
}

extension CenterLabelCell : CenterLabelTableViewCellViewModel {
    var infoMessage: String {
        return title
    }
    
    var detailMessage: String {
        return detail
    }
}

extension CenterLabelCell : TableViewItemViewModel {
    
    var height: Double {
        return CenterLabelTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return CenterLabelTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol CenterLabelTableViewCellViewModel {
    var infoMessage: String { get }
    var detailMessage: String { get }

}

extension CenterLabelTableViewCell: ChartViewDelegate {}

