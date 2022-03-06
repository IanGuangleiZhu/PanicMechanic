//
//  TutorialCalibrateViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

class TutorialCalibrateViewModel: TutorialCalibrateViewModelType {
    
    weak var coordinatorDelegate: TutorialCalibrateViewModelCoordinatorDelegate?
    weak var viewDelegate: TutorialCalibrateViewModelViewDelegate?
    
    var cameraClient: CameraClient
    var localCache: LocalCache
    let fingerDetectService: FingerDetectService
    let isTutorial: Bool
    
    var shouldShowNextButton: Bool {
        return isTutorial
    }
    
    var shouldShowBackButton: Bool {
        return !isTutorial
    }
    
    var shouldShowInfoLabel: Bool {
        return isTutorial
    }

    init(cameraClient: CameraClient, localCache: LocalCache, fingerDetectService: FingerDetectService, isTutorial: Bool) {
        self.cameraClient = cameraClient
        self.localCache = localCache
        self.fingerDetectService = fingerDetectService
        self.isTutorial = isTutorial
    }
    
    deinit {
        teardown()
    }

    func start() {
        // Set the default value of the slider
        let defaultSensitivity = Float(localCache.cameraSensitivity)
        viewDelegate?.updateSlider(value: defaultSensitivity)
        
        // Tell the camera what to do with each frame
        cameraClient.frameHandler = { frame in
            let redness = self.fingerDetectService.detect(pixelBuffer: frame)
            DispatchQueue.main.async {
                self.viewDelegate?.updateDetectedLabel(isDetected: redness != nil)
            }
        }
        
        // Turn on the camera
        enableCamera()
    }
    
    func proceed() {
        coordinatorDelegate?.proceedFromCalibrate()
    }


    func teardown() {
        disableCamera()
    }
    
    func update(sensitivity: Double) {
        localCache.cameraSensitivity = sensitivity
    }
    
    private func enableCamera() {
        if !cameraClient.isRunning {
            cameraClient.start {
                print("Started Camera")
                DefaultVideoClient.toggleTorch(on: true)
            }
        } else {
            print("Camera is already running")
        }
    }
    
    private func disableCamera() {
        if cameraClient.isRunning {
            cameraClient.stop() {
                print("Stopped camera")
                DefaultVideoClient.toggleTorch(on: false)
            }
        } else {
            print("Camera isn't running.")
        }
    }

}
