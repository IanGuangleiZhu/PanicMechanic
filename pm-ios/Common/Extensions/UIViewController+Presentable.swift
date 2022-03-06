//
//  UIViewController+Presentable.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

extension UIViewController: Presentable {
    
    /**
    Get presentable representation of a view controller.

    - Returns: An optional presentable representaion of the view controller.
    */
    func toPresent() -> UIViewController? {
        return self
    }
    
}
