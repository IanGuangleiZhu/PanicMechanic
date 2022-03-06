//
//  TutorialWelcomeViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class TutorialWelcomeViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: TutorialWelcomeViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let messageTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = Strings.tutorialWelcomeMessage
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        textView.textColor = Colors.lightPanicRed
        textView.textAlignment = .left
        return textView
    }()
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(messageTextView)
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
        constrain(messageTextView) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
        }
    }
    
    private func renderNavigationBarButtonItems() {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    private func setup() {
        view.backgroundColor = Colors.bgColor
        title = "Welcome!"
    }

}

// MARK: - Actions -
extension TutorialWelcomeViewController {
    
    @objc func didTapNextButton(_ sender: UIBarButtonItem) {
        viewModel?.proceed()
    }
    
}

// MARK: - View Delegate -
extension TutorialWelcomeViewController: TutorialWelcomeViewModelViewDelegate {}
