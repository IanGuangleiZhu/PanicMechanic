//
//  RatingView.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/31/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class RatingView: UIView {
    
    private let defaultRating: Int = 2
    private lazy var ratingSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumValue = 4
        slider.value = Float(defaultRating)
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "---"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    init(frame: CGRect, options: [String]) {
        super.init(frame: frame)
        setupView(with: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(with: [])
    }
    
    
    @objc
    func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        sender.value = Float(value)
        print(value)
        
        valueLabel.text = (stackView.arrangedSubviews[value] as? UILabel)?.text
    }
    
    private func setupView(with options: [String]) {
        backgroundColor = .green
        addSubview(valueLabel)
        addSubview(ratingSlider)
        addSubview(stackView)
        for text in options {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.numberOfLines = 2
            label.font = .boldSystemFont(ofSize: 14.0)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            stackView.addArrangedSubview(label)
        }
        setupLayout()
    }
    
    private func setupLayout() {
        constrain(valueLabel) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top + 8.0
        }
        constrain(ratingSlider, valueLabel) { view, vL in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == vL.bottom + 8.0
        }
        constrain(stackView, ratingSlider) { view, rS in
            view.leading == rS.leading
            view.trailing == rS.trailing
            view.top == rS.bottom + 8.0
        }
    }
    
}
