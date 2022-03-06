//
//  RecordHRViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import AVFoundation
import Cartography
import Charts
import JGProgressHUD
import Instructions

fileprivate let MOTIVATIONAL_POPUPS = [
    "You’re doing great!",
    "You got this!",
    "We are amazed by you!",
    "Hang in there!",
    "Keep it up!",
    "You’re resilient!",
    "You can do this!",
    "You’re amazing!",
    "Excellent finger placing skills ;)",
    "Way to go!"
]

class RecordHRViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: RecordHRViewModelType? {
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
        vc.delegate = self
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
    
    private let upperContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.lightPanicRed
        return view
    }()
    
    private lazy var previewView: PreviewView = {
        let previewView = PreviewView(frame: .zero)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        //        previewView.backgroundColor = Colors.opaquePink
        //        SynUI.addShadow(to: previewView, color: .black, opacity: 0.5, offset: .init(width: 0, height: 6), radius: 5)
        previewView.elevate(elevation: 4)
        previewView.layer.cornerRadius = 5
        previewView.layer.masksToBounds = true
        return previewView
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.bgColor
        label.text = "0%"
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 40.0)
        return label
    }()
    
    private let motivationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.bgColor
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 18.0)
        return label
    }()
    
    private let lowerContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.chartDescription?.enabled = false
        view.isUserInteractionEnabled = false
        view.noDataText = "No HR Values Available"
        view.noDataTextColor = Colors.lightPanicRed
        if let font = UIFont(name: "SFCompactRounded-Bold", size: 24.0) {
            view.noDataFont = font
        } else {
            view.noDataFont = .systemFont(ofSize: 24.0)
        }
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = false
        view.legend.enabled = false
        view.leftAxis.labelTextColor = Colors.lightPanicRed
        view.rightAxis.enabled = false
        view.xAxis.labelTextColor = Colors.lightPanicRed
        view.xAxis.drawLabelsEnabled = true
        view.xAxis.drawAxisLineEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.xAxis.gridColor = Colors.lightPanicRed
        view.xAxis.granularityEnabled = true
        view.xAxis.granularity = 1
        view.leftAxis.axisMinimum = 40
        view.leftAxis.axisMaximum = 220
        return view
    }()
    
    private let hud = JGProgressHUD(style: .light)
    
    private let motivationTexts = MOTIVATIONAL_POPUPS.choose(2)
    
    // MARK: - Lifecycle -
    deinit {
        chartView.data = nil
    }
    
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(timerContainer)
        timerContainer.addSubview(progressBar)
        view.addSubview(upperContainer)
        upperContainer.addSubview(previewView)
        upperContainer.addSubview(motivationLabel)
        previewView.addSubview(percentLabel)
        view.addSubview(lowerContainer)
        lowerContainer.addSubview(chartView)
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
        chartView.data = nil
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
        constrain(upperContainer, timerContainer) { view, tC in
            view.top == tC.bottom + 8.0
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.height == view.superview!.safeAreaLayoutGuide.height * 0.4
        }
        constrain(previewView) { view in
            view.height == view.superview!.height * 0.6
            view.width == view.superview!.height * 0.6
            view.center == view.superview!.center
        }
        constrain(motivationLabel, previewView) { view, pV in
            view.top == pV.bottom
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
        }
        constrain(percentLabel) { view in
            view.center == view.superview!.center
        }
        constrain(lowerContainer, upperContainer) { view, uC in
            view.top == uC.bottom + 8.0
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom - 8.0
        }
        constrain(chartView) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top + 8.0
            view.bottom == view.superview!.bottom - 8.0
        }
    }
    
    private func setup() {
        title = "Record"
        view.backgroundColor = Colors.bgColor
        //        updateHeartRatePlot(data: [(0, 90), (1, 45), (2, 56), (4, 85), (5, 100), (7, 82)])
    }
    
    private func renderNavigationBarButtonItems() {
        guard let shouldShowCancelButton = viewModel?.shouldShowCancelButton, let shouldShowFinishButton = viewModel?.shouldShowFinishButton else { return }
        
        if shouldShowFinishButton {
            let finishButton = UIBarButtonItem(title: "Finish Attack", style: .done, target: self, action: #selector(didTapFinishButton))
            navigationItem.rightBarButtonItem = finishButton
        }
        if shouldShowCancelButton {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
            navigationItem.leftBarButtonItem = cancelButton
        }
        
    }
    
}

// MARK: - Actions -
extension RecordHRViewController {
    
    @objc func didTapFinishButton(_ sender: UIButton) {
        print("*************************")
        print("TAPPED FINISH , BUTTON")
        print("*************************")
        viewModel?.finishAttack()
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        viewModel?.cancelAttack()
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        viewModel?.proceed()
    }
    
}

// MARK: - View Delegate -
extension RecordHRViewController: RecordHRViewModelViewDelegate {
    
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
    
    func updateProgressBar(progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.progress = progress
        }
    }
    
    func updateDetectionElements(percent: Int, detected: Bool) {
        DispatchQueue.main.async {
            if let first = self.motivationTexts.first, let last = self.motivationTexts.last {
                self.percentLabel.text = "\(percent)%"
                if percent >= 30 && percent < 70 {
                    self.motivationLabel.text = first
                } else if percent >= 70 {
                    self.motivationLabel.text = last
                } else {
                    self.motivationLabel.text = ""
                }
            }
        }
    }
    
    func setPreviewSession(session: AVCaptureSession?) {
        previewView.session = session
    }
    
    /**
     
     Set the data for the heart rate plot.
     - Parameter data: List of (Cycle Index, HR) tuples
     */
    func updateHeartRatePlot(data: [(Int, Int)]) {
        guard data.count > 0 else { return }
        // Scale the x-axis based on our dataset
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = Double(data.count)
        
        let sanitized = sanitize(data: data)
        let values = sanitized.map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i.0), y: Double(i.1), icon: nil)
        }
        let set = LineChartDataSet(entries: values, label: nil)
        set.drawIconsEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.setColor(Colors.lightPanicRed)
        set.setCircleColor(Colors.panicRed)
        set.lineWidth = 2
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        let gradientColors = [Colors.bgColor.cgColor,
                              Colors.panicRed.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set.fillAlpha = 1
        set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set.drawFilledEnabled = true
        let data = LineChartData(dataSet: set)
        chartView.data = data
    }
    
    private func sanitize(data: [(Int, Int)]) -> [(Int, Int)] {
        let missingValues = data.filter { $0.1 == 0 }
        return missingValues.count > 0 ? data.filter { $0.1 != 0 } : data
    }
    
    func showCoachMarks() {
        self.coachMarksController.start(in: .window(over: self))
    }
    
    func showNextCoachMark() {
        self.coachMarksController.flow.showNext()
    }
    
    func hideCoachMarks() {
        self.coachMarksController.stop(immediately: true)
    }
    
}

extension RecordHRViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        if let shouldShowCompleteCoachMarks = viewModel?.shouldShowCompleteCoachMarks, shouldShowCompleteCoachMarks {
            return 1
        }
        return 5
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        if let shouldShowCompleteCoachMarks = viewModel?.shouldShowCompleteCoachMarks, shouldShowCompleteCoachMarks {
            let rightBarButton = self.navigationItem.rightBarButtonItem! as UIBarButtonItem
            let viewRight = rightBarButton.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: viewRight) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        }
        switch(index) {
        case 1:
            return coachMarksController.helper.makeCoachMark(for: progressBar)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: chartView)
        case 3:
            var coachMark = coachMarksController.helper.makeCoachMark(for: previewView)
            coachMark.disableOverlayTap = true
            return coachMark
        case 4:
            return coachMarksController.helper.makeCoachMark(for: chartView)
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
        if let shouldShowCompleteCoachMarks = viewModel?.shouldShowCompleteCoachMarks, shouldShowCompleteCoachMarks {
            hintText = "These screens will cycle until you press Finish Attack."
        } else {
            switch index {
            case 1:
                hintText = "Each step of your measurement is timed and the remaining seconds will be shown here. You will not be timed right now."
            case 2:
                hintText = "After you measure your heart rate once, this will start filling in. On every measurement, a new point will be added."
            case 3:
                hintText = "Place your index finger over your camera and flash. You can view your finger placement here. It needs to get to 100% to read your heart rate correctly."
            case 4:
                hintText = "See? Now you are tracking your heart rate! Your panic in plot form!"
            default:
                hintText = "Great! The first step is to measure your heart rate through the changes in vein coloration in your finger! (pretty cool, huh?)"
            }
        }
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}

extension RecordHRViewController: CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        if index == 2 {
            viewModel?.enableCamera()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didHide coachMark: CoachMark, at index: Int) {
        if index == 4 {
            viewModel?.proceed()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, afterSizeTransition: Bool, at index: Int) {
        
    }
    
    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController, at index: Int) -> Bool {
        if index == 3 {
            return false
        }
        return true
    }
    
}
