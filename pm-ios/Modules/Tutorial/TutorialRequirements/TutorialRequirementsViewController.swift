//
//  TutorialRequirementsViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class TutorialRequirementsViewController: BaseViewController {

    // MARK: - Properties -
    var viewModel: TutorialRequirementsViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.tutorialRequirementsMessage
        label.numberOfLines = 10
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let cameraMessageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.tutorialRequirementsCameraInfo
        label.numberOfLines = 2
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let cameraLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Camera"
        label.numberOfLines = 2
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let cameraSwitch: UISwitch = {
        let kSwitch = UISwitch(frame: .zero)
        kSwitch.translatesAutoresizingMaskIntoConstraints = false
        kSwitch.isOn = false
        kSwitch.tag = 0
        kSwitch.onTintColor = Colors.panicRed
        kSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        return kSwitch
    }()
    
    private let locationMessageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.tutorialRequirementsLocationInfo
        label.numberOfLines = 2
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.numberOfLines = 2
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let locationSwitch: UISwitch = {
        let kSwitch = UISwitch(frame: .zero)
        kSwitch.translatesAutoresizingMaskIntoConstraints = false
        kSwitch.isOn = false
        kSwitch.tag = 1
        kSwitch.onTintColor = Colors.panicRed
        kSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        return kSwitch
    }()
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(messageLabel)
        view.addSubview(cameraMessageLabel)
        view.addSubview(cameraLabel)
        view.addSubview(cameraSwitch)
        view.addSubview(locationMessageLabel)
        view.addSubview(locationLabel)
        view.addSubview(locationSwitch)
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
        constrain(messageLabel) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(cameraMessageLabel, messageLabel) { view, mL in
            view.top == mL.bottom + 32.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(cameraSwitch, cameraMessageLabel) { view, cML in
            view.top == cML.bottom + 8.0
            view.trailing == cML.trailing
        }
        constrain(cameraLabel, cameraMessageLabel, cameraSwitch) { view, cML, cS in
            view.top == cML.bottom + 8.0
            view.leading == cML.leading
            view.trailing == cS.leading
            view.centerY == cS.centerY
        }
        constrain(locationMessageLabel, cameraLabel) { view, cL in
            view.top == cL.bottom + 32.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
        }
        constrain(locationSwitch, locationMessageLabel) { view, lML in
            view.top == lML.bottom + 8.0
            view.trailing == lML.trailing
        }
        constrain(locationLabel, locationMessageLabel, locationSwitch) { view, lML, lS in
            view.top == lML.bottom + 8.0
            view.leading == lML.leading
            view.trailing == lS.leading
            view.centerY == lS.centerY
        }
    }
    
    private func renderNavigationBarButtonItems() {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    private func setup() {
        title = "Requirements"
        view.backgroundColor = Colors.bgColor
    }

}

// MARK: - Actions -
extension TutorialRequirementsViewController {
    
    @objc func didTapNextButton(_ sender: UIBarButtonItem) {
        viewModel?.proceed()
    }
    
    @objc func didTapSwitch(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            viewModel?.requestCameraAccess()
        case 1:
            viewModel?.requestLocationAccess()
        default:
            return
        }
    }
    
}

// MARK: - View Delegate -
extension TutorialRequirementsViewController: TutorialRequirementsViewModelViewDelegate {
    
    func updateCameraSwitch(isOn: Bool) {
        DispatchQueue.main.async {
            self.cameraSwitch.setOn(isOn, animated: true)
            self.cameraSwitch.isEnabled = false
        }
    }
    
    func updateLocationSwitch(isOn: Bool) {
        DispatchQueue.main.async {
            self.locationSwitch.setOn(isOn, animated: true)
            self.locationSwitch.isEnabled = false
        }
    }
   
}
