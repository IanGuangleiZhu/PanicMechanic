//
//  RecordHRInterfaces.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/21/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecordHRViewModelType {
    
    var viewDelegate: RecordHRViewModelViewDelegate? { get set }
    var coordinatorDelegate: RecordHRViewModelCoordinatorDelegate? { get set }

    var practiceModeEnabled: Bool { get }
    var shouldShowCancelButton: Bool { get }
    var shouldShowFinishButton: Bool { get }
    var shouldShowCompleteCoachMarks: Bool { get }
    
    func start()
    
    func teardown()
    func proceed()
    func finishAttack()
    func cancelAttack()

    func startTutorial()
    func stopTutorial()
    func enableCamera()
    func disableCamera()
    
}

protocol RecordHRViewModelCoordinatorDelegate: class {
    
    func proceedFromHRRecorder()
    func dismiss()

}

protocol RecordHRViewModelViewDelegate: class {

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateProgressBar(progress: Float)
    func updateHeartRatePlot(data: [(Int, Int)])
    func updateDetectionElements(percent: Int, detected: Bool)
    func setPreviewSession(session: AVCaptureSession?)
    func showCoachMarks()
    func showNextCoachMark()
    func hideCoachMarks()
}
