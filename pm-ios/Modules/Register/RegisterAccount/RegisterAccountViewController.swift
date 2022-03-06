//
//  RegisterAccountViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/24/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import JGProgressHUD

class RegisterAccountViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: RegisterAccountViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let's create your PanicMechanic account!"
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Colors.panicRed
        textField.textContentType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Colors.panicRed
        textField.textContentType = .password
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        return textField
    }()
    
    private let passwordConfirmTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Colors.panicRed
        textField.textContentType = .password
        textField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Passwords must be at least 8 characters."
        label.textAlignment = .center
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        return label
    }()
    
    private let submitButton: HighlightableButton = {
        let button = HighlightableButton(frame: .zero, unselectedColor: Colors.panicRed, selectedColor: Colors.lightPanicRed)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.actionColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.elevate(elevation: 4.0)
        return button
    }()
    
    private let hud = JGProgressHUD(style: .light)

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(passwordLabel)
        view.addSubview(submitButton)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
}

// MARK: - Layout
extension RegisterAccountViewController {
    
    private func layoutSubviews() {
        constrain(titleLabel) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(emailTextField, titleLabel) { view, tL in
            view.height == 40
            view.top == tL.bottom + 16.0
            view.leading == tL.leading
            view.trailing == tL.trailing
        }
        constrain(passwordTextField, emailTextField) { view, eTF in
            view.height == 40
            view.top == eTF.bottom + 16.0
            view.leading == eTF.leading
            view.trailing == eTF.trailing
        }
        constrain(passwordConfirmTextField, passwordTextField) { view, pTF in
            view.height == 40
            view.top == pTF.bottom + 16.0
            view.leading == pTF.leading
            view.trailing == pTF.trailing
        }
        constrain(passwordLabel, passwordConfirmTextField) { view, pCTF in
            view.top == pCTF.bottom + 16.0
            view.leading == pCTF.leading
            view.trailing == pCTF.trailing
        }
        constrain(submitButton, passwordLabel) { view, pL in
            view.height == 60
            view.top == pL.bottom + 16.0
            view.leading == pL.leading
            view.trailing == pL.trailing
        }
        emailTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
        passwordTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
        passwordConfirmTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
    }
    
    private func setup() {
        title = "Create Account"
        view.backgroundColor = Colors.bgColor
    }
    
}

// MARK: - Actions
extension RegisterAccountViewController {
    
    @objc func didTapSubmitButton(_ sender: UIButton) {
        guard let email = emailTextField.text, email.isEmail() else {
            // Show alert
            showError(message: "Please a valid email address.")
            return
        }
        guard let password = passwordTextField.text, let confirm = passwordConfirmTextField.text else {
            // Show alert
            showError(message: "Please enter a valid password.")
            return
        }
        guard password == confirm else {
            showError(message: "Passwords don't match.")
            return
        }
        viewModel?.register(email: email, password: password)
    }
    
}

// MARK: - View Delegate
extension RegisterAccountViewController: RegisterAccountViewModelViewDelegate {
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view)
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.hud.dismiss(animated: true)
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func showVerificationFailedError() {
        let message = "Failed to send verification link. Please try again later."
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
}
