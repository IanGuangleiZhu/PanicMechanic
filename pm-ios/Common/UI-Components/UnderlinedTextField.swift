//
//  UnderlinedTextField.swift
//  pm-ios
//
//  Created by Synbrix Software on 11/30/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {

}

extension UITextField {
    
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    
    func addUnderline() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 75 - 1, width: 300, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }
    
    func underlined(color: UIColor = .black) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
//
//    func underlined2(){
//        let border = CALayer()
//        let lineWidth = CGFloat(0.3)
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - lineWidth, width:  self.frame.size.width, height: self.frame.size.height)
//        border.borderWidth = lineWidth
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//    }
}
