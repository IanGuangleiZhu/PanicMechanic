//
//  AuthResetViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import JGProgressHUD

class AuthResetViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: AuthResetViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lightPanicRed
        label.text = "Please provide a valid email address."
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        label.numberOfLines = 4
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
    
    private let submitButton: ActionButton = {
        let button = ActionButton(frame: .zero, bgColor: Colors.actionColor, highlightColor: Colors.opaquePink)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send Reset", for: .normal)
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
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
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
    
    // MARK: - Private Helpers -
    private func layoutSubviews() {
        constrain(titleLabel) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(emailTextField, titleLabel) { view, tL in
            view.height == 40
            view.top == tL.bottom + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(submitButton, emailTextField) { view, eTF in
            view.height == 60
            view.top == eTF.bottom + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        emailTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
    }
    
    private func setup() {
        title = "Forgot Password"
        view.backgroundColor = Colors.bgColor
    }

}

// MARK: - Actions -
extension AuthResetViewController {
    
    @objc func didTapSubmitButton(_ sender: UIBarButtonItem) {
        guard let email = emailTextField.text else {
            // TODO: Show error message
            return
        }
        viewModel?.submitEmail(email: email)
    }
    
}

// MARK: - View Delegate -
extension AuthResetViewController: AuthResetViewModelViewDelegate {
    
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
    
    func showSuccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Reset Link Sent", message: "Check your email for a link to reset your password.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Reset Failed", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
}
