//
//  PanicButton.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/28/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

protocol PanicButtonDelegate: class {
    func didTransitionToActiveState()
}

class PanicButton: UIView {
    
    weak var delegate: PanicButtonDelegate?
        
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: .zero)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        progressView.progressTintColor = UIColor(red: 0.439, green: 0.082, blue: 0.314, alpha: 1.000)
        progressView.trackTintColor = UIColor.lightGray
        progressView.layer.cornerRadius = 90.0
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(rotationAngle: .pi / -2)
        progressView.isHidden = true
        return progressView
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to Begin"
        label.font = .boldSystemFont(ofSize: 18.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longPress)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    @objc func handleLongPress(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        switch sender.state {
        case .began:
            print("long press began")
        case .cancelled:
            print("long press cancelled")
        case .changed:
            print("long press changed")
            backgroundColor = .lightGray
        case .ended:
            print ("long press ended")
            backgroundColor = .clear
        case .failed:
            print("long press failed")
        case .possible:
            print("long press possible")
//        case .recognized:
//            print("long press recognized")
        @unknown default:
            return
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        switch sender.state {
        case .began:
            print("tap began")
        case .cancelled:
            print("tap cancelled")
        case .changed:
            print("tap changed")
        case .ended:
            print ("tap ended")
            backgroundColor = .clear
        case .failed:
            print("tap failed")
        case .possible:
            print("tap possible")
//        case .recognized:
//            print("tap recognized")
        @unknown default:
            return
        }
             
//        if sender.state == .ended {      // Move the view down and to the right when tapped.
//           let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
//              sender.view!.center.x += 100
//              sender.view!.center.y += 100
//           })
//           animator.startAnimation()
//        }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        setActiveState()
    }
    
    private func setupView() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [Colors.panicRed.cgColor, Colors.opaquePink.cgColor]
        gradientLayer.locations = [0.0, 0.7]
        addSubview(progressView)
        addSubview(instructionsLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        constrain(progressView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
        }
        constrain(instructionsLabel) { view in
            view.center == view.superview!.center
            view.width == view.superview!.width * 0.9
        }
    }
    
    func setActiveState() {
        CATransaction.begin()

        let toColors = [UIColor.lightGray, UIColor.lightGray]
        var cgColorsTo = [CGColor]()
        for color in toColors {
           cgColorsTo.append(color.cgColor)
        }
        let gradientChangeColor = CABasicAnimation(keyPath: "colors")
        gradientChangeColor.duration = 0.5
        gradientChangeColor.toValue = cgColorsTo
        gradientChangeColor.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeColor.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock{ [weak self] in
            self?.progressView.isHidden = false
            self?.instructionsLabel.text = "Place fingertip on camera"
            self?.delegate?.didTransitionToActiveState()
        }

        self.layer.add(gradientChangeColor, forKey: "colorChange")
        CATransaction.commit()
    }
    
    func setInactiveState() {
//        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
//        let toColors = [Colors.panicRed, Colors.opaquePink]
//        gradientLayer.animateChanges(to: toColors, duration: 0.5)
    }
    
    func updateInstructions(text: String) {
        instructionsLabel.text = text
    }
    
    func setProgress(progress: Float) {
        progressView.progress = progress
    }

}

extension CAGradientLayer
{
    func animateChanges(to colors: [UIColor],
                        duration: TimeInterval)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            // Set to final colors when animation ends
            self.colors = colors.map{ $0.cgColor }
        })
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = duration
        animation.toValue = colors.map{ $0.cgColor }
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        add(animation, forKey: "changeColors")
        CATransaction.commit()
    }
}
