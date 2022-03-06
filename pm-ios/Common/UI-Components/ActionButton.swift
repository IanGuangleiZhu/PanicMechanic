//
//  ActionButton.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/5/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    private let bgColor: UIColor
    private let highlightColor: UIColor
    
    init(frame: CGRect, bgColor: UIColor, highlightColor: UIColor) {
        self.bgColor = bgColor
        self.highlightColor = highlightColor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightColor : bgColor
        }
    }
    
}

