//
//  TutorialCompleteViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class TutorialCompleteViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: TutorialCompleteViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let termsTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = Strings.tutorialCompleteMessage
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = true
        textView.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        textView.textColor = Colors.lightPanicRed
        textView.textAlignment = .left
        return textView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.tutorialCompleteInfo
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        label.numberOfLines = 5
        label.textAlignment = .center
        return label
    }()
    
    private let endButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.tutorialCompleteButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
        button.setTitleColor(Colors.panicRed, for: .normal)
        return button
    }()
    

    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        view.addSubview(endButton)
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
    
    // MARK: - Private Helpers -
    private func layoutSubviews() {
        constrain(endButton) { view in
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
            view.centerX == view.superview!.centerX
        }
        constrain(termsTextView, endButton) { view, eB in
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.bottom == eB.top - 8.0
        }
    }
    
    private func setup() {
        view.backgroundColor = Colors.bgColor
        title = "Done!"
    }

}

// MARK: - Actions -
extension TutorialCompleteViewController {
    
    @objc func didTapSubmitButton(_ sender: UIBarButtonItem) {
        viewModel?.skip()
    }
    
}

// MARK: - View Delegate -
extension TutorialCompleteViewController: TutorialCompleteViewModelViewDelegate {}

