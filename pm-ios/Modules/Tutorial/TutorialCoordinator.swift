//
//  TutorialCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

fileprivate let TUTORIAL_ENABLED = true

protocol TutorialCoordinatorDelegate: class {
    func didFinish(from coordinator: TutorialCoordinator, with user: AuthenticatedUser?)
}

class TutorialCoordinator: BaseCoordinator {
    
    // MARK: - Delegates -
    weak var delegate: TutorialCoordinatorDelegate?

    // MARK: - Dependencies -
    private let user: AuthenticatedUser?
    private let router: Routable
    private let apiClient: APIClient
    private var localCache: LocalCache
    private let cameraClient: CameraClient
    private let isAbridged: Bool
    
    // MARK: - Properties -
    private var shouldCompleteTutorial: Bool = false
    
    init(user: AuthenticatedUser?, router: Routable, apiClient: APIClient, localCache: LocalCache, cameraClient: CameraClient, isAbridged: Bool) {
        self.user = user
        self.router = router
        self.apiClient = apiClient
        self.localCache = localCache
        self.cameraClient = cameraClient
        self.isAbridged = isAbridged
    }
    
    // MARK: - BaseCoordinator -
    override func start() {
        showWelcomeView()
    }
        
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        delegate?.didFinish(from: self, with: user)
    }
    
    // MARK: - Private Helpers -
    private func showWelcomeView() {
        let viewModel = TutorialWelcomeViewModel(localCache: localCache, isAbridged: isAbridged)
        viewModel.coordinatorDelegate = self
        let controller = TutorialWelcomeViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showRequirementsView() {
        let viewModel = TutorialRequirementsViewModel()
        viewModel.coordinatorDelegate = self
        let controller = TutorialRequirementsViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showCalibrateView() {
        let fingerDetectService = FingerDetectAPIService(localCache: localCache)
        let viewModel = TutorialCalibrateViewModel(cameraClient: cameraClient, localCache: localCache, fingerDetectService: fingerDetectService, isTutorial: TUTORIAL_ENABLED)
        viewModel.coordinatorDelegate = self
        let controller = TutorialCalibrateViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showHomeView(with user: AuthenticatedUser?) {
        let userService = UserAPIService(apiClient: apiClient)
        let viewModel = HomeViewModel(user: user, localCache: localCache, userService: userService, cycleService: nil, episodeLocationService: nil, headlessUserService: nil, isTutorial: TUTORIAL_ENABLED)
         viewModel.coordinatorDelegate = self
         let controller = HomeViewController()
         controller.viewModel = viewModel
         router.setRootModule(controller, hideBar: false)
    }
    
    private func showHRView() {
        let fingerDetectService = FingerDetectAPIService(localCache: localCache)
        let heartRateService = HeartRateAPIService()
        let episodeService = EpisodeAPIService(apiClient: apiClient)
        let viewModel = RecordHRViewModel(cameraClient: cameraClient, localCache: localCache, fingerDetectService: fingerDetectService, heartRateService: heartRateService, episodeService: episodeService, cycleService: nil, episodeLocationService: nil, isTutorial: TUTORIAL_ENABLED)
        viewModel.coordinatorDelegate = self
        let controller = RecordHRViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showRatingView(questionType: RatingQuestionType) {
        let viewModel = RecordRatingViewModel(localCache: localCache, questionType: questionType, cycleService: nil, isTutorial: TUTORIAL_ENABLED)
        viewModel.coordinatorDelegate = self
        let controller = RecordRatingViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showQuestionView() {
        let viewModel = RecordQuestionViewModel(localCache: localCache, cycleService: nil, isTutorial: TUTORIAL_ENABLED, user: nil)
        viewModel.coordinatorDelegate = self
        let controller = RecordQuestionViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showPromptView() {
        let viewModel = RecordPromptViewModel(localCache: localCache, cycleService: nil, isTutorial: TUTORIAL_ENABLED, user: nil)
        viewModel.coordinatorDelegate = self
        let controller = RecordPromptViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showCompleteView() {
        let viewModel = TutorialCompleteViewModel()
        viewModel.coordinatorDelegate = self
        let controller = TutorialCompleteViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
}

// MARK: - Presentable -
extension TutorialCoordinator: Presentable {
    /**
        Allows passing of coordinator to a router.
     */
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }
    
}

// MARK: - Coordinator Delegates -
extension TutorialCoordinator: TutorialWelcomeViewModelCoordinatorDelegate {}
extension TutorialCoordinator: TutorialRequirementsViewModelCoordinatorDelegate {}
extension TutorialCoordinator: TutorialCalibrateViewModelCoordinatorDelegate {}
extension TutorialCoordinator: HomeViewModelCoordinatorDelegate {}
extension TutorialCoordinator: RecordHRViewModelCoordinatorDelegate {}
extension TutorialCoordinator: RecordRatingViewModelCoordinatorDelegate {}
extension TutorialCoordinator: RecordQuestionViewModelCoordinatorDelegate {}
extension TutorialCoordinator: RecordPromptViewModelCoordinatorDelegate {}
extension TutorialCoordinator: TutorialCompleteViewModelCoordinatorDelegate {}

extension TutorialCoordinator {
    
    func dismiss() {}
    
    func proceedFromWelcome() {
        if isAbridged {
            showHomeView(with: nil)
        } else {
            showRequirementsView()
        }
    }
    
    func proceedFromRequirements() {
        showCalibrateView()
    }
    
    func proceedFromCalibrate() {
        showHomeView(with: nil)
    }
    
    func proceedFromHome(with user: PanicMechanicUser?) {
        showHRView()
    }
    
    func proceedFromHRRecorder() {
        if shouldCompleteTutorial {
            showCompleteView()
        } else {
            shouldCompleteTutorial = true
            showRatingView(questionType: .anxiety)
        }
    }
    
    func proceedFromAnxietyQuestion() {
        showQuestionView()
    }
    
    func proceedFromTriggerQuestion() {
        showRatingView(questionType: .stress)
    }
    
    func proceedFromQualityQuestion() {
        showPromptView()
    }
    
    func proceedFromPrompt() {
        showHRView()
    }

    func proceedFromComplete() {
        print("setting tutorial complete")
        if !localCache.isTutorialComplete {
            localCache.isTutorialComplete = true
        }
        finish()
    }

}
