//
//  ReauthenticationViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/26/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import JGProgressHUD

class ReauthenticationViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: ReauthenticationViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    // MARK: - UI Elements -
    private let upperContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logo: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "PanicMechanicLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
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

    private let logInButton: ActionButton = {
        let button = ActionButton(frame: .zero, bgColor: Colors.actionColor, highlightColor: Colors.opaquePink)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.actionColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.elevate(elevation: 4.0)
        return button
    }()
    
    private let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero, bgColor: .clear, highlightColor: Colors.opaquePink)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(Colors.opaquePink, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private let hud = JGProgressHUD(style: .light)

    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        view.addSubview(upperContainer)
        upperContainer.addSubview(logo)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(cancelButton)
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
    
    // MARK: - Private Helpers -
    private func layoutSubviews() {
        constrain(upperContainer) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.height == view.superview!.safeAreaLayoutGuide.height * 0.5
        }
        constrain(logo) { view in
            view.center == view.superview!.center
            view.width == view.height * 0.33
            view.leading == view.superview!.leading + 64.0
            view.trailing == view.superview!.trailing - 64.0
        }
        constrain(emailTextField, upperContainer) { view, uC in
            view.height == 40
            view.top == uC.bottom + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(passwordTextField, emailTextField) { view, eTF in
            view.height == 40
            view.top == eTF.bottom + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(logInButton, passwordTextField) { view, pTF in
            view.height == 60
            view.top == pTF.bottom + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(cancelButton, logInButton) { view, lIB in
            view.top == lIB.bottom + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        emailTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
        passwordTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
    }
    
    private func setup() {
        view.backgroundColor = Colors.bgColor
    }
}

// MARK: - Actions -
extension ReauthenticationViewController {
    
    @objc func didTapLogInButton(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel?.reauthenticate(email: email, password: password)
        }
        
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        viewModel?.cancel()
    }
    
}

// MARK: - View Delegate -
extension ReauthenticationViewController: ReauthenticationViewModelViewDelegate {
    
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
            let alert = UIView.basicAlert(title: "Error", message: message, actionTitle: "OK")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
