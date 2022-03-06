//
//  DefaultVideoClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import AVFoundation
import Accelerate.vImage

class DefaultVideoClient: NSObject, CameraClient {
    
    var isRunning: Bool {
        return session.isRunning
    }
    var session: AVCaptureSession = AVCaptureSession()
    var frameHandler: ((CVImageBuffer) -> Void)?
    private let frameRate: CMTimeScale
    private let sessionQueue: DispatchQueue = DispatchQueue(label: "default-video-session-queue")
    private let bufferQueue: DispatchQueue = DispatchQueue(label: "default-video-buffer-queue")
    private var prepared: Bool = false
    
    init(frameRate: CMTimeScale) {
        self.frameRate = frameRate
        super.init()
    }
    
    private func prepare(completion: (() -> Void)?) {
        configure(completion: completion)
    }
    
    func start(completion: (() -> Void)?) {
        if !prepared {
            prepare {
                self.prepared = true
                self.startStream(completion: completion)
            }
        } else {
            startStream(completion: completion)
        }
    }
    
    private func startStream(completion: (() -> Void)?) {
        log.info("Starting stream of video frames...")
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            } else {
                print("Session already running")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func stop(completion: (() -> Void)?) {
        if !prepared {
            prepare {
                self.prepared = true
                self.stopStream(completion: completion)
            }
        } else {
            stopStream(completion: completion)
        }
    }
    
    private func stopStream(completion: (() -> Void)?) {
        log.info("Stopping stream of video frames...")
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            } else {
                print("Session already stopped")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    private func configure(completion: (() -> Void)?) {
        sessionQueue.async {
            log.info("Configuring camera client...")
            self.session.beginConfiguration()
            
            // Add video input.
            guard let videoDevice = AVCaptureDevice.default(for: .video) else {
                print("Default video device is unavailable.")
                return
            }
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if self.session.canAddInput(videoDeviceInput) {
                    self.session.addInput(videoDeviceInput)
                }
            } catch {
                print("Cant create video device input")
                return
            }
            
            // Set the device frame rate to 30Hz
            videoDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: self.frameRate, flags: .valid, epoch: 0)
            videoDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: self.frameRate, flags: .valid, epoch: 0)
            
            // Add video output
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            if self.session.canAddOutput(videoDataOutput) {
                self.session.addOutput(videoDataOutput)
            } else {
                print("Could not add video data output to the session")
                return
            }
            self.session.commitConfiguration()
            completion?()
        }
    }

}

extension DefaultVideoClient: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Check if we can grab the pixel buffer from the image frame
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Process the pixel values
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        frameHandler?(pixelBuffer)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
    
}
