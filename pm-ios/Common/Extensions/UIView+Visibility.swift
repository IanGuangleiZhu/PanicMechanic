//
//  UIView+Visibility.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
    Hides the view.
    */
    func hide() {
        self.isHidden = true
        self.alpha = 0.0
    }
    
    /**
    Show the view.
     */
    func show() {
        self.isHidden = false
        self.alpha = 1.0
    }
}
