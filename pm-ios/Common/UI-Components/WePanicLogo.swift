//
//  WePanicLogo.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/11/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

fileprivate let LOGO_TEXT = "WePanic"
fileprivate let FONT_NAME = "11S01 Black Tuesday"

class WePanicLogo: UILabel {
    
    let size: CGFloat
    
    init(frame: CGRect, size: CGFloat) {
        self.size = size
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let customFont = UIFont(name: FONT_NAME, size: size) {
            attributes[NSAttributedString.Key.font] = customFont
        } else {
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: size)
        }
        let logoString = NSMutableAttributedString(string: LOGO_TEXT, attributes: attributes)
        logoString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.panicRed, range: NSRange(location:0,length:2))
        logoString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.opaquePink, range: NSRange(location: 2,length: 5))
        attributedText = logoString
    }
    
}

class WePanicTextField: UITextField {
    
    let size: CGFloat
    
    init(frame: CGRect, size: CGFloat) {
        self.size = size
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        
        
        
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let customFont = UIFont(name: FONT_NAME, size: size) {
            attributes[NSAttributedString.Key.font] = customFont
        } else {
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: size)
        }
        let logoString = NSMutableAttributedString(string: LOGO_TEXT, attributes: attributes)
        logoString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.panicRed, range: NSRange(location:0,length:2))
        logoString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.opaquePink, range: NSRange(location: 2,length: 5))
        attributedText = logoString
    }
    
        internal lazy var usernameTextField: UITextField = {
            let textField = UITextField(frame: .zero)
            textField.translatesAutoresizingMaskIntoConstraints = false
    //        textField.textColor = UIColor(red:0.44, green:0.08, blue:0.31, alpha:1.0)
    //        textField.textContentType = .emailAddress
            textField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    //        textField.leftViewMode = .always
    //        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    //        textField.keyboardType = .emailAddress
            return textField
        }()
        
        internal lazy var passwordTextField: UITextField = {
            let textField = UITextField(frame: .zero)
            textField.translatesAutoresizingMaskIntoConstraints = false
    //        textField.textColor = UIColor(red:0.44, green:0.08, blue:0.31, alpha:1.0)
    //        textField.textContentType = .password
            textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    //        textField.leftViewMode = .always
    //        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    ////        textField.text = "test1234"
    //        textField.isSecureTextEntry = true
    //        textField.keyboardType = .default
            return textField
        }()
    
}
