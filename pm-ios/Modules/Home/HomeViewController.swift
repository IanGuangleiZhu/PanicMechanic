//
//  HomeViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Instructions

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements
    lazy var coachMarksController: CoachMarksController = {
        let vc = CoachMarksController()
        vc.overlay.allowTap = true
        vc.dataSource = self
        return vc
    }()
    
    private let panicContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.lightPanicRed
        return view
    }()

    private let panicButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPanicButton), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.elevate(elevation: 4.0)
        return button
    }()
    
    private let panicImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Wrench")
        return imageView
    }()
    
    private let panicLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to Begin"
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 32.0)
        label.textColor = Colors.bgColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var practiceSwitchView: LabeledSwitchView = {
        let switchView = LabeledSwitchView(frame: .zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.text = "Practice Mode"
        switchView.font = UIFont(name: "SFCompactRounded-Semibold", size: 18.0)
        switchView.textColor = .lightGray
        switchView.delegate = self
        switchView.onTintColor = Colors.panicRed
        switchView.offTintColor = .lightGray
        return switchView
    }()
    
    private let practiceButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Help"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.addSubview(panicContainer)
        view.addSubview(practiceSwitchView)
        panicContainer.addSubview(panicButton)
        panicContainer.addSubview(panicLabel)
        panicButton.addSubview(panicImageView)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Animations.removeRippleEffect(from: panicButton)
        Animations.addRippleEffect(to: panicButton)
        viewModel?.startTutorial()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopTutorial()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        panicContainer.layer.cornerRadius = panicContainer.frame.size.width/2.0
        panicContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        panicButton.layer.cornerRadius = (view.layoutMarginsGuide.layoutFrame.width * 0.7)/2.0
    }
    
}

// MARK: - Actions -
extension HomeViewController {
    
    @objc func didTapPanicButton(_ sender: UIButton) {
        log.info("Panic button tapped.")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        viewModel?.panic()
    }
    
    @objc func didTapPracticeSwitch(_ sender: UISwitch) {
        
    }
    
}

// MARK: - Layout
extension HomeViewController {
    
    private func layoutSubviews() {
        constrain(panicContainer) { view in
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.height == view.superview!.safeAreaLayoutGuide.height * 0.9
        }
        constrain(practiceSwitchView, panicContainer) { view, pC in
            view.bottom == pC.top - 8.0
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
            view.width == view.superview!.layoutMarginsGuide.width * 0.6
            view.centerX == view.superview!.centerX
        }
        constrain(panicButton) { view in
            view.height == view.superview!.layoutMarginsGuide.width * 0.7
            view.width == view.superview!.layoutMarginsGuide.width * 0.7
            view.top == view.superview!.top + 64.0
            view.centerX == view.superview!.centerX
        }
        constrain(panicImageView) { view in
            view.height == view.superview!.width * 0.4
            view.width == view.superview!.width * 0.4
            view.center == view.superview!.center
        }
        constrain(panicLabel, panicButton) { view, pB in
            view.centerX == pB.centerX
            view.top == pB.bottom + 64.0
        }
    }

    private func setup() {
        view.backgroundColor = Colors.bgColor
        navigationItem.title = "Home"
    }

}


// MARK: - View Delegate -
extension HomeViewController: HomeViewModelViewDelegate {
    
    func showCoachMarks() {
        self.coachMarksController.start(in: .window(over: self))
    }
    
    func hideCoachMarks() {
        self.coachMarksController.stop(immediately: true)
    }
    
    func showErrorMessage() {
        print("Error")
    }
    
    func enablePanicButton() {
        DispatchQueue.main.async {
            self.panicButton.backgroundColor = Colors.panicRed
            self.panicButton.isEnabled = true
        }
    }
    
    func disablePanicButton() {
        DispatchQueue.main.async {
            self.panicButton.backgroundColor = .lightGray
            self.panicButton.isEnabled = false
        }
    }
    
}

// MARK: - LabeledSwitchViewDelegate
extension HomeViewController: LabeledSwitchViewDelegate {
    
    func didTapSwitch(control: UISwitch) {
        DispatchQueue.main.async {
            self.practiceSwitchView.textColor = control.isOn ? Colors.panicRed : .lightGray
            self.viewModel?.togglePractice(isOn: control.isOn)
        }
    }
   
}

extension HomeViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {

        switch(index) {
        case 1:
            return coachMarksController.helper.makeCoachMark(for: practiceSwitchView)
        case 2:
            
            var coachMark = coachMarksController.helper.makeCoachMark(for: panicButton) { (frame: CGRect) -> UIBezierPath in
                // This will create a circular cutoutPath, perfect for the circular avatar!
                return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
            }
            // Since we've allowed the user to tap on the overlay to show the
            // next coach mark, we'll disable this ability for the current
            // coach mark to force the user to perform the appropriate action.
            coachMark.disableOverlayTap = true

            // We'll also enable the ability to touch what's inside
            // the cutoutPath.
            coachMark.allowTouchInsideCutoutPath = true
            
            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark(for: self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText = ""
        switch index {
        case 1:
            hintText = "If you ever want to practice recording an attack, enable practice mode. The data will not be saved."
        case 2:
            hintText = "Let's begin. Start by tapping this big button."
        default:
            hintText = "This is your home screen. You will start all of your panic attack measurements here."
        }
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}
