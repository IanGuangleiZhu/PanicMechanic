//
//  RecordingView.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation
import Accelerate.vImage

protocol RecordingViewDelegate: class {
    func didReceiveHeartRateSample(hr: Int)
//    var onPanicButtonPressed: (() -> Void)? { get set }
}

class RecordingView: UIView {
    
    private lazy var panicButton: PanicButton = {
        let panicButton = PanicButton(frame: .zero)
        panicButton.translatesAutoresizingMaskIntoConstraints = false
        panicButton.backgroundColor = .clear
        return panicButton
    }()
    
    private lazy var plotView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
//        contentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.backgroundColor = .purple
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(panicButton)
        addSubview(plotView)
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        constrain(panicButton) { view in
            view.top == view.superview!.top
            view.centerX == view.superview!.centerX
            view.height == 200
            view.width == 200
        }
        constrain(plotView, panicButton) { view, pB in
            view.top == pB.bottom + 16.0
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }
    
    private func setupActions() {
//        panicButton.addTarget(self, action: #selector(panic), for: .touchUpInside)
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize(width: 300, height: 300)
    }
    
    override func updateConstraints() {
        //      headerViewTop.constant = headerViewTopConstant
        super.updateConstraints()
    }
    
    // MARK: - Objective-C Action Methods -
    @objc
    private func panic(_ sender: UIButton) {
        // Vibrate with heavy tone
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
//        if let hidden = self.tabBarController?.tabBar.isHidden, hidden {
//            self.tabBarController?.setTabBarHidden(false, animated: true)
//        } else {
//            self.tabBarController?.setTabBarHidden(true, animated: true)
//        }
    }
    
}

fileprivate var REDNESS_THRESHOLD: Double = 1900000

// SOURCES: https://developer.apple.com/documentation/accelerate/vimage/applying_vimage_operations_to_video_sample_buffers

extension RecordingView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Check if we can grab the pixel buffer from the image frame
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Process the pixel values
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
//        processPixelBuffer(pixelBuffer: pixelBuffer)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //        print("didDrop")
    }
}
