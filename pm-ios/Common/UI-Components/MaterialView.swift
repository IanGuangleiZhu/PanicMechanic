//
//  MaterialView.swift
//  pm-ios
//
//  Created by Synbrix Software on 12/6/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

protocol MaterialView {
    func elevate(elevation: Double)
}

extension UIView: MaterialView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        self.layer.shadowOpacity = 0.24
    }
}
