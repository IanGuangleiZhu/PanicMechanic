//
//  RecordRatingViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Instructions

class RecordRatingViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: RecordRatingViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
    lazy var coachMarksController: CoachMarksController = {
        let vc = CoachMarksController()
        vc.overlay.allowTap = true
        //        vc.overlay.blurEffectStyle = .extraLight
        //        vc.overlay.color = Colors.bgColor
        vc.dataSource = self
        return vc
    }()
    
    private lazy var nextButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
        barButton.isEnabled = false
        return barButton
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
    
    private lazy var instructionsContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.elevate(elevation: 4)
        return view
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
        label.textColor = Colors.opaquePink
        label.numberOfLines = 5
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "---"
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 36.0)
        label.textColor = Colors.bgColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.lightPanicRed
        return view
    }()
    
    private lazy var ratingSlider: IndentedSlider = {
        let slider = IndentedSlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .touchUpInside)
        slider.minimumValue = 1
        slider.minimumTrackTintColor = Colors.panicRed
        slider.maximumTrackTintColor = Colors.bgColor
        return slider
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(timerContainer)
        timerContainer.addSubview(progressBar)
        view.addSubview(instructionsContainer)
        instructionsContainer.addSubview(instructionsLabel)
        view.addSubview(ratingContainer)
        ratingContainer.addSubview(valueLabel)
        ratingContainer.addSubview(ratingSlider)
        ratingContainer.addSubview(stackView)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        constrain(instructionsContainer, timerContainer) { view, tC in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == tC.bottom + 8.0
            view.height == view.superview!.height * 0.2
        }
        constrain(instructionsLabel) { view in
            view.leading == view.superview!.leading + 8.0
            view.trailing == view.superview!.trailing - 8.0
            view.top == view.superview!.top + 16.0
            view.bottom == view.superview!.bottom - 16.0
        }
        constrain(ratingContainer, instructionsContainer) { view, iC in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == iC.bottom + 32.0
            view.height == view.superview!.safeAreaLayoutGuide.height * 0.3
        }
        constrain(ratingSlider) { view in
            view.leading == view.superview!.leading + 8.0
            view.trailing == view.superview!.trailing - 8.0
            view.centerY == view.superview!.centerY
        }
        constrain(valueLabel, ratingSlider) { view, rS in
            view.leading == rS.leading
            view.trailing == rS.trailing
            view.centerX == rS.centerX
            view.bottom == rS.top - 8.0
        }
        constrain(stackView, ratingSlider) { view, rS in
            view.leading == rS.leading
            view.trailing == rS.trailing
            view.top == rS.bottom + 8.0
        }
    }
    
    private func setup() {
        view.backgroundColor = Colors.bgColor
    }
    
    private func renderNavigationBarButtonItems() {
        navigationItem.rightBarButtonItem = nextButton
    }
    
}

// MARK: - Actions -
extension RecordRatingViewController {
    
    @objc func didTapNextButton(_ sender: UIBarButtonItem) {
        let rating = Int(ratingSlider.value)
        viewModel?.proceed(with: rating)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        if !nextButton.isEnabled {
            nextButton.isEnabled = true
        }
        let value = roundf(sender.value)
        ratingSlider.setValue(value, animated: false)
        valueLabel.text = viewModel?.mapValueToOption(value: Int(value))
    }
    
}

// MARK: - View Delegate -
extension RecordRatingViewController: RecordRatingViewModelViewDelegate {
    
    func updateTitle(title: String) {
        self.title = title
    }
    
    func updateProgressBar(progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.progress = progress
        }
    }
    
    func updateQuestion(title: String, instructions: String, options: [String]) {
        //        titleLabel.text = title
        DispatchQueue.main.async {
            self.instructionsLabel.text = instructions
            self.ratingSlider.maximumValue = Float(options.count)
            self.ratingSlider.value = options.count % 2 == 0 ? Float(options.count/2) : Float((options.count + 1)/2)
            for option in options {
                let label = UILabel(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = option
                label.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
                label.textColor = Colors.bgColor
                label.textAlignment = .center
                label.numberOfLines = 2
                self.stackView.addArrangedSubview(label)
            }
//            self.layoutSubviews()
        }
    }
    
    func showCoachMarks() {
        self.coachMarksController.start(in: .window(over: self))
    }
    
    func hideCoachMarks() {
        self.coachMarksController.stop(immediately: true)
    }
    
}

extension RecordRatingViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {

        switch(index) {
        case 1:
            return coachMarksController.helper.makeCoachMark(for: ratingContainer)
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
        if let qtype = viewModel?.getQuestionType() {
            switch index {
            case 1:
                if qtype == .anxiety {
                    hintText = "Slide to give your response 1-10 (10 being the most anxious ever)"
                } else {
                    hintText = "Again, slide to give your response."
                }
            default:
                if qtype == .anxiety {
                    hintText = "After you measure your heart rate, the next screen will ask you how anxious you feel in that moment."
                } else {
                    hintText = "The second: rate your stress level today. Or exercise, sleep, and a few others. This will help you better understand your panic patterns."
                }
            }
            
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}
