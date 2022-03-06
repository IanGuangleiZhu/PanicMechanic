//
//  LabeledSwitchView.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

protocol LabeledSwitchViewDelegate: class {
    func didTapSwitch(control: UISwitch)
}

class LabeledSwitchView: UIView {
    
    // MARK: - Properties -
    weak var delegate: LabeledSwitchViewDelegate?
    
    var text: String? {
        didSet {
            switchLabel.text = text
        }
    }
    
    var textColor: UIColor? {
        didSet {
            switchLabel.textColor = textColor
        }
    }
    
    var font: UIFont? {
        didSet {
            switchLabel.font = font
        }
    }
    
    var isOn: Bool = false {
        didSet {
            switchControl.isOn = isOn
        }
    }
    
    var onTintColor: UIColor? {
        didSet {
            switchControl.onTintColor = onTintColor
        }
    }
    
    var offTintColor: UIColor? {
        didSet {
            switchControl.backgroundColor = offTintColor
            switchControl.layer.cornerRadius = 16.0
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            switchControl.isEnabled = isEnabled
        }
    }
    
    // MARK: - UI Elements -
    private let switchLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let switchControl: UISwitch = {
        let kSwitch = UISwitch(frame: .zero)
        kSwitch.translatesAutoresizingMaskIntoConstraints = false
        // NOTE: We use touchUpInside because sometimes we want to intercept the call before the animation completes
        kSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        return kSwitch
    }()
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout -
extension LabeledSwitchView {
    
    private func setupView() {
        addSubview(switchLabel)
        addSubview(switchControl)
        setupLayout()
    }
    
    private func setupLayout() {
        constrain(switchControl) { view in
            view.centerY == view.superview!.centerY
            view.trailing == view.superview!.trailing
        }
        constrain(switchLabel, switchControl) { view, sC in
            view.leading == view.superview!.leading
            view.centerY == view.superview!.centerY
            view.trailing == sC.leading
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let width = switchLabel.intrinsicContentSize.width + switchControl.intrinsicContentSize.width
        let height = switchLabel.intrinsicContentSize.height + switchControl.intrinsicContentSize.height
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - Actions -
extension LabeledSwitchView {
    
    @objc private func didTapSwitch(_ sender: UISwitch) {
        delegate?.didTapSwitch(control: sender)
    }
    
}
