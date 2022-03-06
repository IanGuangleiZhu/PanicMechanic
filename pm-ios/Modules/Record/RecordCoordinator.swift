//
//  RecordCoordinator.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

protocol RecordCoordinatorDelegate: class {
    func didFinish(from coordinator: RecordCoordinator)
}

class RecordCoordinator: BaseCoordinator {
    
    // MARK: - Delegates -
    weak var delegate: RecordCoordinatorDelegate?
    
    // MARK: - Dependencies -
    private let router: Routable
    private let apiClient: APIClient
    private let localCache: LocalCache
    private let localStore: LocalStore
    private let cameraClient: CameraClient
    private let user: PanicMechanicUser? // Optional because we don't need to load user during tutorial
    
    // MARK: - Properties -
    private var triggerShown = false
    private var qualityQuestions: [RatingQuestionType] = [.stress, .sleep, .exercise, .diet, .substances].shuffled()

    init(router: Routable, apiClient: APIClient, localCache: LocalCache, localStore: LocalStore, cameraClient: CameraClient, user: PanicMechanicUser?) {
        self.router = router
        self.apiClient = apiClient
        self.localCache = localCache
        self.localStore = localStore
        self.cameraClient = cameraClient
        self.user = user
    }
    
    // MARK: - BaseCoordinator -
    override func start() {
        showHRView()
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
//        localStore.clear()
//        apiClient.enableNetwork { error in
//            if let error = error {
//                log.warning("Error occured enabling network, finishing anyway:", context: error)
//            }
            self.delegate?.didFinish(from: self)
//        }
    }

}

// MARK: - Presentable -
extension RecordCoordinator: Presentable {
    /**
        Allows passing of coordinator to a router.
     */
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }
    
}

// MARK: - Coordinator Delegates -RecordRatingViewModelCoordinatorDelegate
extension RecordCoordinator: RecordHRViewModelCoordinatorDelegate {}
extension RecordCoordinator: RecordRatingViewModelCoordinatorDelegate {}
extension RecordCoordinator: RecordQuestionViewModelCoordinatorDelegate {}
extension RecordCoordinator: RecordPromptViewModelCoordinatorDelegate {}
extension RecordCoordinator {
    
    func dismiss() {
        DispatchQueue.main.async {
            self.finish()
        }
    }
    
    func proceedFromHRRecorder() {
        DispatchQueue.main.async {
            self.showRatingView(questionType: .anxiety)
        }
    }
    
    func proceedFromAnxietyQuestion() {
        DispatchQueue.main.async {
            if !self.triggerShown {
                self.triggerShown = true
                self.showQuestionView()
            } else {
                if let nextQuestion = self.qualityQuestions.first {
                    self.qualityQuestions.removeFirst()
                    self.showRatingView(questionType: nextQuestion)
                } else {
                    self.showPromptView()
                }
            }
        }
    }
    
    func proceedFromTriggerQuestion() {
        DispatchQueue.main.async {
            self.showHRView()
        }
    }
    
    func proceedFromQualityQuestion() {
        DispatchQueue.main.async {
            self.showPromptView()
        }
    }
    
    func proceedFromPrompt() {
        DispatchQueue.main.async {
            self.showHRView()
        }
    }
    
}

// MARK: - Private Helpers -
extension RecordCoordinator {
    
    private func showHRView() {
        let fingerDetectService = FingerDetectAPIService(localCache: localCache)
        let heartRateService = HeartRateAPIService()
        let episodeService = EpisodeAPIService(apiClient: apiClient)
        let cycleService = CycleAPIService(localStore: localStore)
        let episodeLocationService = EpisodeLocationAPIService(localStore: localStore)
        let viewModel = RecordHRViewModel(cameraClient: cameraClient, localCache: localCache, fingerDetectService: fingerDetectService, heartRateService: heartRateService, episodeService: episodeService, cycleService: cycleService, episodeLocationService: episodeLocationService, isTutorial: false)
        viewModel.coordinatorDelegate = self
        let controller = RecordHRViewController()
        controller.viewModel = viewModel
        self.router.setRootModule(controller, hideBar: false)
    }
    
    private func showRatingView(questionType: RatingQuestionType) {
        let cycleService = CycleAPIService(localStore: localStore)
        let viewModel = RecordRatingViewModel(localCache: localCache, questionType: questionType, cycleService: cycleService, isTutorial: false)
        viewModel.coordinatorDelegate = self
        let controller = RecordRatingViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showQuestionView() {
        let cycleService = CycleAPIService(localStore: localStore)
        let viewModel = RecordQuestionViewModel(localCache: localCache, cycleService: cycleService, isTutorial: false, user: user)
        viewModel.coordinatorDelegate = self
        let controller = RecordQuestionViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
    private func showPromptView() {
        let cycleService = CycleAPIService(localStore: localStore)
        let viewModel = RecordPromptViewModel(localCache: localCache, cycleService: cycleService, isTutorial: false, user: user)
        viewModel.coordinatorDelegate = self
        let controller = RecordPromptViewController()
        controller.viewModel = viewModel
        router.setRootModule(controller, hideBar: false)
    }
    
}
