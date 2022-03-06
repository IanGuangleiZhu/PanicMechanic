//
//  RegisterDemographicViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class RegisterDemographicViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: RegisterDemographicViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements
    private let genderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I identify as"
        label.textAlignment = .center
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        return label
    }()
    
    private let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["MALE", "FEMALE", "NON-BINARY"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I am age"
        label.textAlignment = .center
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        return label
    }()
    
    private let ageTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Colors.panicRed
        textField.attributedPlaceholder = NSAttributedString(string: "Age (Optional)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I want to be called"
        label.textAlignment = .center
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Colors.panicRed
        textField.textContentType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "Nickname (Optional)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.keyboardType = .default
        textField.text = "Anonymous Mechanic"
        return textField
    }()
    
    private let nicknameDetailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This can be your first name or any name you want to be called by PanicMechanic. Alphabetical letters and spaces only."
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = Colors.lightPanicRed
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        return label
    }()
    
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(genderLabel)
        view.addSubview(genderSegmentedControl)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameDetailLabel)
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
extension RegisterDemographicViewController {
    
    private func layoutSubviews() {
        constrain(genderLabel) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(genderSegmentedControl, genderLabel) { view, gL in
            view.top == gL.bottom + 32.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(ageLabel, genderSegmentedControl) { view, gSC in
            view.top == gSC.bottom + 32.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(ageTextField, ageLabel) { view, aL in
            view.top == aL.bottom + 8.0
            view.leading == aL.leading
            view.trailing == aL.trailing
            view.height == 40
        }
        constrain(nicknameLabel, ageTextField) { view, aTF in
            view.top == aTF.bottom + 32.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(nicknameTextField, nicknameLabel) { view, nL in
            view.top == nL.bottom + 8.0
            view.leading == nL.leading
            view.trailing == nL.trailing
            view.height == 40
        }
        constrain(nicknameDetailLabel, nicknameTextField) { view, nTF in
            view.top == nTF.bottom + 16.0
            view.leading == nTF.leading
            view.trailing == nTF.trailing
        }
        ageTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
        nicknameTextField.addLine(position: .bottom, color: Colors.panicRed, height: 1.0)
    }
    
    private func renderNavigationBarButtonItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didTapSubmitButton))
        navigationItem.rightBarButtonItem = nextButton
    }

    private func setup() {
        title = "About You"
        view.backgroundColor = Colors.bgColor
    }
}

// MARK: - Actions
extension RegisterDemographicViewController {
    
    @objc func didTapSubmitButton(_ sender: UIBarButtonItem) {
        guard genderSegmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment, let gender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) else {
            // Show error
            return
        }
        // Process age field if value provided
        if let text = ageTextField.text, let age = Int(text) {
            if age < 18 {
                DispatchQueue.main.async {
                    let alert = UIView.basicAlert(title: "Sign Up Failed", message: "You must be 18 or older to register.", actionTitle: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                viewModel?.submitDemographics(gender: gender, age: age, nickname: nicknameTextField.text)
            }
        } else {
            viewModel?.submitDemographics(gender: gender, age: -1, nickname: nicknameTextField.text)
        }
    }
    
    @objc private func updateTextField(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.ageTextField.text = Date.birthdayFormatter.string(from: sender.date)
        }
    }
    
}

// MARK: - View Delegate
extension RegisterDemographicViewController: RegisterDemographicViewModelViewDelegate {
    
    func showErrorMessage() {
        print("Error")
    }
    
}

fileprivate let TRIGGER_MAX_CHARS = 30
fileprivate let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

