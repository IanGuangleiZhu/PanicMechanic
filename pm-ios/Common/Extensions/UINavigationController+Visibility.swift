//
//  UINavigationController+Visibility.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /**
    Hide the navigation bar.
     */
    func hideBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
}
