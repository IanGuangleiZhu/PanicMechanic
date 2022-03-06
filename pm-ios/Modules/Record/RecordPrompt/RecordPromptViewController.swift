//
//  RecordPromptViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Instructions

class RecordPromptViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: RecordPromptViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements
    lazy var coachMarksController: CoachMarksController = {
        let vc = CoachMarksController()
        vc.overlay.allowTap = true
        //        vc.overlay.blurEffectStyle = .extraLight
        //        vc.overlay.color = Colors.bgColor
        vc.dataSource = self
        return vc
    }()
    
    private let timerContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = Colors.panicRed
        //        progressView.observedProgress = step.progress
        progressView.layer.cornerRadius = 5.0
        return progressView
    }()
    
    private lazy var promptContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.elevate(elevation: 4)
        return view
    }()
    
    private lazy var recoveryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
        label.textColor = Colors.lightPanicRed
        label.numberOfLines = 5
        return label
    }()

    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(timerContainer)
        timerContainer.addSubview(progressBar)
        view.addSubview(promptContainer)
        promptContainer.addSubview(recoveryLabel)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    // MARK: - Private Helpers -
    private func layoutSubviews() {
        constrain(timerContainer) { view in
            view.top == view.superview!.safeAreaLayoutGuide.top + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.height == view.superview!.safeAreaLayoutGuide.height * 0.02
        }
        constrain(progressBar) { view in
            view.height == view.superview!.height * 0.8
            view.width == view.superview!.width
            view.center == view.superview!.center
        }
        constrain(promptContainer, timerContainer) { view, tC in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == tC.bottom + 8.0
            view.height == view.superview!.height * 0.2
        }
        constrain(recoveryLabel) { view in
            view.leading == view.superview!.leading + 8.0
            view.trailing == view.superview!.trailing - 8.0
            view.top == view.superview!.top + 16.0
            view.bottom == view.superview!.bottom - 16.0
        }
    }
    
    private func setup() {
        title = "Prompt"
        view.backgroundColor = Colors.bgColor
    }
    
    private func renderNavigationBarButtonItems() {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
        navigationItem.rightBarButtonItem = nextButton
    }

}

// MARK: - Actions -
extension RecordPromptViewController {
    
    @objc func didTapNextButton(_ sender: UIButton) {
        viewModel?.proceed()
    }
    
}

// MARK: - View Delegate -
extension RecordPromptViewController: RecordPromptViewModelViewDelegate {
    
    func showCoachMarks() {
        DispatchQueue.main.async {
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    
    func hideCoachMarks() {
        DispatchQueue.main.async {
            self.coachMarksController.stop(immediately: true)
        }
    }
    
    func updateProgressBar(progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.progress = progress
        }
    }
    
    func updateRecoveryLabel(duration: Double) {
        DispatchQueue.main.async {
            self.recoveryLabel.text = String(format: "Based on your average panic attack length you have %.1f minutes remaining", duration)
        }
    }
    
}

// MARK: - CoachMarksControllerDataSource -
extension RecordPromptViewController: CoachMarksControllerDataSource {
    

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {

        switch(index) {
        case 1:
            return coachMarksController.helper.makeCoachMark(for: recoveryLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: recoveryLabel)
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
            hintText = "This tells you how long you have left before your panic attack will likely end."
        case 2:
            hintText = "\"You only have to endure this for 2 more minutes, you got this!\""
        default:
            hintText = "This screen will show up after you've tracked at least one attack."
        }
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}

extension RecordPromptViewController: CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {

    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didHide coachMark: CoachMark, at index: Int) {
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, afterSizeTransition: Bool, at index: Int) {
        
    }
    
    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController, at index: Int) -> Bool {
        return true
    }
    
}
