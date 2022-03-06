//
//  UIBarButtonItem+Visibility.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

// SOURCE: https://spin.atomicobject.com/2018/03/15/extend-uibarbuttonitem/
public extension UIBarButtonItem {
    
    /**
        Give bar button items the ability to be hidden.
     */
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = Colors.panicRed // This sets the tinColor back to the default. If you have a custom color, use that instead
            }
        }
    }
}
