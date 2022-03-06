//
//  HighlightableButton.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/27/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

class HighlightableButton: UIButton {
    
    // MARK: - Properties
    private let unselectedColor: UIColor
    private let selectedColor: UIColor
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? selectedColor : unselectedColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            let highlighted = isHighlighted ? selectedColor : unselectedColor
            backgroundColor = isEnabled ? highlighted : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    init(frame: CGRect, unselectedColor: UIColor, selectedColor: UIColor) {
        self.unselectedColor = unselectedColor
        self.selectedColor = selectedColor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
