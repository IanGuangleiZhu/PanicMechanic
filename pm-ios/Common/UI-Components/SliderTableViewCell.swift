//
//  SliderTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 2/1/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Charts

class SliderTableViewCell: UITableViewCell {
    
    static var standardHeight: Double {
        return 120.0
    }
    
    static var reuseIdentifier: String {
        return "slider.cell"
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cell Title"
        label.textColor = Colors.panicRed
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 16.0)
        return label
    }()
    
    private let ratingContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let ratingSlider: IndentedSlider = {
        let slider = IndentedSlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.minimumTrackTintColor = Colors.panicRed
        slider.maximumTrackTintColor = Colors.panicRed
        slider.isEnabled = false
        return slider
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()

    func configure(with viewModel: SliderTableViewCellViewModel?) {
        titleLabel.text = viewModel?.titleString
        if let value = viewModel?.sliderValue {
            ratingSlider.setValue(value, animated: false)
        }
        if let options = viewModel?.sliderOptions {
            for (idx, subview) in stackView.arrangedSubviews.enumerated() {
                if let label = subview as? UILabel {
                    label.text = options[idx]
                }
            }
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingContainer)
        ratingContainer.addSubview(ratingSlider)
        ratingContainer.addSubview(stackView)
        constrain(titleLabel) { view in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
        }
        constrain(ratingContainer, titleLabel) { view, tL in
            view.leading == tL.leading
            view.trailing == tL.trailing
            view.top == tL.bottom + 8.0
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
        }
        constrain(ratingSlider) { view in
            view.leading == view.superview!.leading + 8.0
            view.trailing == view.superview!.trailing - 8.0
            view.top == view.superview!.top
        }
        constrain(stackView, ratingSlider) { view, rS in
            view.leading == rS.leading
            view.trailing == rS.trailing
            view.top == rS.bottom + 8.0
        }
        (1...5).forEach { i in
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "SFCompactRounded-Semibold", size: 12.0)
            label.textColor = Colors.lightPanicRed
            label.textAlignment = .center
            label.numberOfLines = 2
            stackView.addArrangedSubview(label)
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        ratingSlider.value = 0
    }
    
}

struct SliderCell {
    
    let title: String
    let value: Float
    let options: [String]
    
    init(title: String, value: Float, options: [String]) {
        self.title = title
        self.value = value
        self.options = options
    }
    
}

extension SliderCell : SliderTableViewCellViewModel {
    
    var titleString: String {
        return title
    }
    
    var sliderValue: Float {
        return value
    }
    
    var sliderOptions: [String] {
        return options
    }

}

extension SliderCell : TableViewItemViewModel {
    
    var height: Double {
        return SliderTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return SliderTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol SliderTableViewCellViewModel {
    var titleString: String { get }
    var sliderValue: Float { get }
    var sliderOptions: [String] { get }
}

