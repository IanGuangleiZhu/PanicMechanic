//
//  RegisterVerifyViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import JGProgressHUD

class RegisterVerifyViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: RegisterVerifyViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let resendButton: ActionButton = {
        let button = ActionButton(frame: .zero, bgColor: Colors.actionColor, highlightColor: Colors.opaquePink)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Resend Link", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.actionColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapResendButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.elevate(elevation: 4.0)
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(Colors.panicRed, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private let hud = JGProgressHUD(style: .light)
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        view.addSubview(titleLabel)
        view.addSubview(resendButton)
        view.addSubview(exitButton)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.checkVerificationStatus()
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
        constrain(resendButton, titleLabel) { view, tL in
            view.height == 60
            view.top == tL.bottom + 16.0
            view.leading == tL.leading
            view.trailing == tL.trailing
        }
        constrain(exitButton, resendButton) { view, rB in
            view.height == 60
            view.top == rB.bottom + 16.0
            view.centerX == rB.centerX
        }
    }
    
    private func setup() {
        title = "Email Verification"
        view.backgroundColor = Colors.bgColor
    }

}

// MARK: - Actions -
extension RegisterVerifyViewController {
    
    @objc func didTapResendButton(_ sender: UIButton) {
        viewModel?.resendLink()
    }
    
    @objc func didTapExitButton(_ sender: UIBarButtonItem) {
        if isBeingPresented {
            log.info("VIEW CONTROLLER IS BEING PRESENTED")
        }
        viewModel?.cancel()
    }
        
    @objc func didTapChangePasswordButton(_ sender: UIButton) {
        viewModel?.changePassword()
    }
}

// MARK: - View Delegate -
extension RegisterVerifyViewController: RegisterVerifyViewModelViewDelegate {
    
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
    
    func updateTitleLabel(with email: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = "A verification link has been sent to \(email), please click the link to complete registration."
        }
    }
    
    func showAlertMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIView.basicAlert(title: title, message: message, actionTitle: "OK")
            self.present(alert, animated: false)
        }
    }
}
