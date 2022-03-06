//
//  TutorialCalibrateViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class TutorialCalibrateViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: TutorialCalibrateViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    private let fingerInstructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.text = "Place and hold your index finger over your camera and flash like so:"
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let placementImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "FingerPlacement")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detectionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.panicRed
        label.numberOfLines = 2
        label.text = "Undetected"
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        return label
    }()
    private let sliderInstructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 6
        label.lineBreakMode = .byWordWrapping
        label.text = "Move the slider until the label says DETECTED. You want the slider value to be as high as possible while still detecting your finger."
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 24.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    private let sensitivitySlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = 1000000
        slider.maximumValue = 2000000
        slider.tintColor = Colors.panicRed
        return slider
    }()
    
    private let settingsInfoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.text = "This can always be adjusted later in the Settings menu."
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 16.0)
        label.textColor = Colors.lightPanicRed
        return label
    }()
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(fingerInstructionsLabel)
        view.addSubview(placementImageView)
        view.addSubview(detectionLabel)
        view.addSubview(sliderInstructionsLabel)
        view.addSubview(sensitivitySlider)
        if let shouldShowInfoLabel = viewModel?.shouldShowInfoLabel, shouldShowInfoLabel {
            view.addSubview(settingsInfoLabel)
        }
        layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.teardown()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
    // MARK: - Private Helpers -
    private func layoutSubviews() {
        constrain(fingerInstructionsLabel) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading + 8.0
            view.trailing == view.superview!.layoutMarginsGuide.trailing - 8.0
        }
        constrain(placementImageView, fingerInstructionsLabel) { view, fIL in
            view.top == fIL.bottom + 16.0
            view.width == view.height * 0.71
            view.leading == view.superview!.leading + 128.0
            view.trailing == view.superview!.trailing - 128.0
        }
        constrain(detectionLabel, placementImageView) { view, pIV in
            view.top == pIV.bottom + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading + 8.0
            view.trailing == view.superview!.layoutMarginsGuide.trailing - 8.0
        }
        constrain(sliderInstructionsLabel, detectionLabel) { view, dL in
            view.top == dL.bottom + 16.0
            view.leading == view.superview!.layoutMarginsGuide.leading + 8.0
            view.trailing == view.superview!.layoutMarginsGuide.trailing - 8.0
        }
        constrain(sensitivitySlider, sliderInstructionsLabel) { view, sIL in
            view.top == sIL.bottom + 8.0
            view.width == view.superview!.layoutMarginsGuide.width * 0.8
            view.centerX == view.superview!.centerX
        }
        if let shouldShowInfoLabel = viewModel?.shouldShowInfoLabel, shouldShowInfoLabel {
            constrain(settingsInfoLabel, sensitivitySlider) { view, sS in
                view.top == sS.bottom + 16.0
                view.leading == sS.leading + 8.0
                view.trailing == sS.trailing - 8.0
                view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
            }
        }
        
        let minLabel = UILabel(frame: .zero)
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.text = "L"
        minLabel.textAlignment = .center
        minLabel.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        minLabel.textColor = Colors.panicRed
        let maxLabel = UILabel(frame: .zero)
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.text = "H"
        maxLabel.textAlignment = .center
        maxLabel.font = UIFont(name: "SFCompactRounded-Bold", size: 24.0)
        maxLabel.textColor = Colors.panicRed
        view.addSubview(minLabel)
        view.addSubview(maxLabel)
        
        constrain(minLabel, sensitivitySlider) { view, sS in
            view.centerY == sS.centerY
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == sS.leading
        }
        constrain(maxLabel, sensitivitySlider) { view, sS in
            view.centerY == sS.centerY
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.leading == sS.trailing
        }
    }
    
    private func renderNavigationBarButtonItems() {
        if let shouldShouldNextButton = viewModel?.shouldShowNextButton, shouldShouldNextButton {
            let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
            navigationItem.rightBarButtonItem = nextButton
        }
        if let shouldShowBackButton = viewModel?.shouldShowBackButton, shouldShowBackButton {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    private func setup() {
        title = "Calibration"
        view.backgroundColor = Colors.bgColor
    }
    
}

// MARK: - Actions -
extension TutorialCalibrateViewController {
    
    @objc func didTapNextButton(_ sender: UIBarButtonItem) {
        viewModel?.proceed()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let sensitivity = Double(sender.value)
        viewModel?.update(sensitivity: sensitivity)
    }
    
    @objc func didTapBackButton(_ sender: UIBarButtonItem) {
        viewModel?.proceed()
    }
    
    
}

// MARK: - View Delegate -
extension TutorialCalibrateViewController: TutorialCalibrateViewModelViewDelegate {
    
    func updateDetectedLabel(isDetected: Bool) {
        DispatchQueue.main.async {
            self.detectionLabel.text = isDetected ? "Detected" : "Undetected"
        }
    }
    
    func updateSlider(value: Float) {
        DispatchQueue.main.async {
            self.sensitivitySlider.setValue(value, animated: true)
        }
    }
    
}
