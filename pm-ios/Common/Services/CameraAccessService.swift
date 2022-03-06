//
//  CameraAccessService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import AVFoundation

protocol CameraAccessService {
    func requestAccess(completion: ((Bool) -> Void)?)
}

class CameraAccessAPIService {}

// MARK: - API
extension CameraAccessAPIService: CameraAccessService {
    
    func requestAccess(completion: ((Bool) -> Void)?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in completion?(granted) }
        default:
            completion?(false)
        }
    }
    
}

