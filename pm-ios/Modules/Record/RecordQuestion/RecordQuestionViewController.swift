//
//  RecordQuestionViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import Instructions

fileprivate let DEFAULT_ITEMS = [
    "Caffeine or Other Substance",
    "Conflict",
    "Finances",
    "Health",
    "Performance",
    "Physical Surroundings",
    "Social Situation",
    "Workload"
]
fileprivate let TRIGGER_MAX_CHARS = 30
fileprivate let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "


class RecordQuestionViewController: BaseViewController {
    
    // MARK: - Properties -
    var viewModel: RecordQuestionViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - UI Elements -
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
    
    lazy var coachMarksController: CoachMarksController = {
        let vc = CoachMarksController()
        vc.overlay.allowTap = true
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    private var triggerTextField : UITextField?
    
    private let instructionsContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.elevate(elevation: 4)
        return view
    }()
    
    private let tableContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.elevate(elevation: 4)
        return view
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Which of the following most relate to your current panic attack?"
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 18.0)
        label.textColor = Colors.lightPanicRed
        label.numberOfLines = 2
        return label
    }()

    private lazy var addButton: ActionButton = {
        let button = ActionButton(frame: .zero, bgColor: Colors.panicRed, highlightColor: Colors.opaquePink)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 42.0)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = Colors.panicRed
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        button.addTarget(self, action: #selector(addTrigger), for: .touchUpInside)
        button.elevate(elevation: 4)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.reuseIdentifier)
        tableView.register(QuestionHeaderView.self, forHeaderFooterViewReuseIdentifier: QuestionHeaderView.reuseIdentifier)
        tableView.layer.cornerRadius = 5.0
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        renderNavigationBarButtonItems()
        view.addSubview(timerContainer)
        timerContainer.addSubview(progressBar)
        view.addSubview(instructionsContainer)
        view.addSubview(tableContainer)
//        view.addSubview(addButton)
        instructionsContainer.addSubview(instructionsLabel)
        tableContainer.addSubview(tableView)
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        addButton.layer.cornerRadius = 75.0/2.0
//    }
    
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
        constrain(tableContainer, instructionsContainer) { view, vC in
            view.leading == view.superview!.layoutMarginsGuide.leading
            view.trailing == view.superview!.layoutMarginsGuide.trailing
            view.top == vC.bottom + 8.0
            view.bottom == view.superview!.safeAreaLayoutGuide.bottom
        }
        constrain(instructionsLabel) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top + 16.0
            view.bottom == view.superview!.bottom - 16.0
        }
        constrain(tableView) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    
    private func setup() {
        title = "Trigger"
        view.backgroundColor = Colors.bgColor
    }
    
    private func renderNavigationBarButtonItems() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
}

// MARK: - Actions -
extension RecordQuestionViewController {
    
    @objc func didTapNextButton(_ sender: UIBarButtonItem) {
        viewModel?.proceed()
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        viewModel?.addTrigger()
    }
    
}

// MARK: - View Delegate -
extension RecordQuestionViewController: RecordQuestionViewModelViewDelegate {
    
    func updateProgressBar(progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.progress = progress
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
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
    
    func showAddCustomTriggerAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: "Add Custom Trigger", message: "You can remove custom triggers in the Settings menu.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                self.triggerTextField = textField
                self.triggerTextField?.delegate = self
                self.triggerTextField?.placeholder = "Trigger Name (max 24 characters)"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                self.viewModel?.resume()
            }
            let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
                if let tf = alertController.textFields?[0], let trigger = tf.text {
                    self.viewModel?.handle(trigger: trigger)
                }
                self.viewModel?.resume()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            alertController.preferredAction = saveAction
            self.present(alertController, animated: true, completion: {
                self.viewModel?.pause()
            })
        }
    }
    
}

// MARK: - UITableViewDelegate -
extension RecordQuestionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Enable the next button once an option is selected
        nextButton.isEnabled = true
        
        viewModel?.didSelect(at: indexPath)
    }
    
}

// MARK: - UITableViewDataSource -
extension RecordQuestionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.reuseIdentifier, for: indexPath) as! QuestionTableViewCell
        cell.textLabel?.text = viewModel?.item(at: indexPath)
        cell.textLabel?.font = UIFont(name: "SFCompactRounded-Regular", size: 18.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuestionHeaderView.reuseIdentifier) as! QuestionHeaderView
        let headerText = section == 0 ? "My Triggers" : "PanicMechanic Triggers"
        
        // We create a header object directly because we are not using TableController
        let header = QuestionHeader(title: headerText)
        headerView.configure(with: header)
        return headerView
    }

}

// MARK: - UITextFieldDelegate -
extension RecordQuestionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
            
        // Get all restricted characters
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted

        // Filter new character if it is restricted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        // If character is valid, check that we are under our character limit
        if string == filtered {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= TRIGGER_MAX_CHARS
        }
        return false
    }
    
}


// MARK: - CoachMarksControllerDataSource -
extension RecordQuestionViewController: CoachMarksControllerDataSource {
    

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {

        switch(index) {
        case 1:
            let pathMaker = { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(rect: frame)
            }

            var coachMark = coachMarksController.helper.makeCoachMark(for: tableView,
                                                                      cutoutPathMaker: pathMaker)
            coachMark.displayOverCutoutPath = true

            return coachMark
        case 2:
            let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
            let viewLeft = leftBarButton.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: viewLeft) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
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
            hintText = "You will then choose the relevant trigger from the list."
        case 2:
            hintText = "You can also add your own triggers by tapping the + button."
        default:
            hintText = "The next screen will ask you a question about your panic attack. There are two types of questions. The first: what do you think triggered it this time?"
        }
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}

extension RecordQuestionViewController: CoachMarksControllerDelegate {
    
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
