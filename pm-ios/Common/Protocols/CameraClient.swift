//
//  CameraClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import AVFoundation
import Accelerate.vImage

protocol CameraClient {
    var isRunning: Bool { get }
    var torchEnabled: Bool { get }
    var session: AVCaptureSession { get }
    var frameHandler: ((CVImageBuffer) -> Void)? { get set }
    func start(completion: (() -> Void)?)
    func stop(completion: (() -> Void)?)
    static func toggleTorch(on: Bool)
}

extension CameraClient {
    
    var torchEnabled: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.isTorchActive
    }
    
    //// SOURCE: hackingwithswift.com/example-code/media/how-to-turn-on-the-camera-flashlight-to-make-a-torch
    public static func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }
        DispatchQueue.main.async {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    if device.torchMode == .off {
                        device.torchMode = .on
                    }
                } else {
                    if device.torchMode == .on {
                        device.torchMode = .off
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
}

