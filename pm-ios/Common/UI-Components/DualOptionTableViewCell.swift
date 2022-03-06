//
//  DualOptionTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 11/4/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class DualOptionTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 48.0
    }
    
    static var reuseIdentifier: String {
        return "dualOption.cell"
    }
    
    private lazy var option1ImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var option1Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    private lazy var option2ImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var option2Label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    func configure(with viewModel: DualOptionTableViewCellViewModel?) {
        option1Label.text = viewModel?.o1String
        option2Label.text = viewModel?.o2String
        option1ImageView.image = viewModel?.o1Image
        option2ImageView.image = viewModel?.o2Image
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
        let containerLeft = UIView(frame: .zero)
        containerLeft.translatesAutoresizingMaskIntoConstraints = false
        let containerRight = UIView(frame: .zero)
        containerRight.translatesAutoresizingMaskIntoConstraints = false

        
        let stackView1 = UIStackView(frame: .zero)
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.alignment = .fill
        stackView1.distribution = .fillEqually
        stackView1.axis = .vertical
        stackView1.spacing = 1
        let stackView2 = UIStackView(frame: .zero)
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.alignment = .fill
        stackView2.distribution = .fillEqually
        stackView2.axis = .vertical
        stackView2.spacing = 1
        
        let valueLabel1 = UILabel(frame: .zero)
        valueLabel1.translatesAutoresizingMaskIntoConstraints = false
        valueLabel1.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        valueLabel1.text = "Duration"
        
        let valueLabel2 = UILabel(frame: .zero)
        valueLabel2.translatesAutoresizingMaskIntoConstraints = false
        valueLabel2.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        valueLabel2.text = "Trigger"
        
        contentView.addSubview(containerLeft)
        contentView.addSubview(containerRight)
        constrain(containerLeft) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top + 8.0
            view.bottom == view.superview!.bottom - 8.0
            view.width == view.superview!.width * 0.5
        }
        constrain(containerRight, containerLeft) { view, cL in
            view.leading == cL.trailing
            view.top == view.superview!.top + 8.0
            view.bottom == view.superview!.bottom - 8.0
            view.trailing == view.superview!.trailing
        }
        
        stackView1.addArrangedSubview(option1Label)
        stackView1.addArrangedSubview(valueLabel1)
        stackView2.addArrangedSubview(option2Label)
        stackView2.addArrangedSubview(valueLabel2)
        
        containerLeft.addSubview(option1ImageView)
        containerLeft.addSubview(stackView1)
        
        containerRight.addSubview(option2ImageView)
        containerRight.addSubview(stackView2)
        
        constrain(option1ImageView) { view in
            view.leading == view.superview!.leading + 4.0
            view.centerY == view.superview!.centerY
            view.height == 25
            view.width == 25
        }
        constrain(stackView1, option1ImageView) { view, o1I in
            view.leading == o1I.trailing + 4.0
            view.centerY == view.superview!.centerY
        }
        
        constrain(option2ImageView) { view in
            view.leading == view.superview!.leading + 4.0
            view.centerY == view.superview!.centerY
            view.height == 25
            view.width == 25
        }
        constrain(stackView2, option2ImageView) { view, o2I in
            view.leading == o2I.trailing + 4.0
            view.centerY == view.superview!.centerY
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        option1Label.text = nil
        option2Label.text = nil
    }
    
}

struct DualOptionCell {
    
    private let option1Text: String
    private let option1Image: UIImage?
    private let option2Text: String
    private let option2Image: UIImage?

    init(text1: String, image1: UIImage?, text2: String, image2: UIImage?) {
        self.option1Text = text1
        self.option1Image = image1
        self.option2Text = text2
        self.option2Image = image2
    }
    
}

extension DualOptionCell : DualOptionTableViewCellViewModel {
    var o1String: String {
        return option1Text
    }
    
    var o2String: String {
        return option2Text
    }
    var o1Image: UIImage? {
        return option1Image
    }
    
    var o2Image: UIImage? {
        return option2Image
    }
}

extension DualOptionCell : TableViewItemViewModel {
    
    var height: Double {
        return DualOptionTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return DualOptionTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol DualOptionTableViewCellViewModel {
    var o1String: String { get }
    var o2String: String { get }
    var o1Image: UIImage? { get }
    var o2Image: UIImage? { get }
}
