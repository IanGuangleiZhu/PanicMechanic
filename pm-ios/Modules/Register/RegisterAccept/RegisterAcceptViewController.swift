//
//  RegisterAcceptViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class RegisterAcceptViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: RegisterAcceptViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements
    private let termsTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.text = Strings.registerAcceptMessage
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        textView.textColor = Colors.lightPanicRed
        textView.textAlignment = .center
        if let rtfPath = Bundle.main.url(forResource: "PanicMechanicTerms", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                textView.attributedText = attributedStringWithRtf
            } catch let error {
                print("Got an error \(error)")
            }
        }
        return textView
    }()
    
    private lazy var acceptSwitchView: LabeledSwitchView = {
        let switchView = LabeledSwitchView(frame: .zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.text = Strings.registerAcceptDetail
        switchView.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        switchView.textColor = Colors.lightPanicRed
        switchView.delegate = self
        switchView.onTintColor = Colors.panicRed
        return switchView
    }()
    
    private let finishButton: HighlightableButton = {
        let button = HighlightableButton(frame: .zero, unselectedColor: Colors.panicRed, selectedColor: Colors.lightPanicRed)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proceed", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        button.layer.cornerRadius = 5.0
        button.setTitleColor(Colors.bgColor, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.elevate(elevation: 4.0)
        return button
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        if let shouldShowControls = viewModel?.shouldShowControls, shouldShowControls {
            view.addSubview(finishButton)
            view.addSubview(acceptSwitchView)
        }
        view.addSubview(termsTextView)
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
extension RegisterAcceptViewController {
        
    private func layoutSubviews() {
        if let shouldShowControls = viewModel?.shouldShowControls, shouldShowControls {
            constrain(finishButton) { view in
                view.height == 60
                view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
                view.leading == view.superview!.layoutMarginsGuide.leading
                view.trailing == view.superview!.layoutMarginsGuide.trailing
            }
            constrain(acceptSwitchView, finishButton) { view, fB in
                view.bottom == fB.top - 16.0
                view.leading == fB.leading
                view.trailing == fB.trailing
            }
            constrain(termsTextView, acceptSwitchView) { view, aSW in
                view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
                view.leading == aSW.leading
                view.trailing == aSW.trailing
                view.bottom == aSW.top - 8.0
            }
        } else {
            constrain(termsTextView) { view in
                view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
                view.leading == view.superview!.layoutMarginsGuide.leading
                view.trailing == view.superview!.layoutMarginsGuide.trailing
                view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
            }
        }

    }
    
    private func renderNavigationBarButtonItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Terms", style: .plain, target: nil, action: nil)
    }
    
    private func setup() {
        title = "Terms of Service"
        view.backgroundColor = Colors.bgColor
    }
    
}

// MARK: - Actions
extension RegisterAcceptViewController {
    
    @objc func didTapFinishButton(_ sender: UIButton) {
        viewModel?.acceptTerms()
    }
    
}

// MARK: - View Delegate
extension RegisterAcceptViewController: RegisterAcceptViewModelViewDelegate {}

// MARK: - LabeledSwitchViewDelegate
extension RegisterAcceptViewController: LabeledSwitchViewDelegate {
    
    func didTapSwitch(control: UISwitch) {
        DispatchQueue.main.async {
            self.finishButton.isEnabled = control.isOn
        }
    }
   
}
