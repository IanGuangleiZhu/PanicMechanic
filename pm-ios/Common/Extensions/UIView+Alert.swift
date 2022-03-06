//
//  UIView+Alert.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Create a basic alert with a single action.
     - Parameter title: Alert title.
     - Parameter message: Alert message.
     - Parameter actionTitle: Action title.
     
     - Returns: A presentable alert.
     */
    static func basicAlert(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
}
