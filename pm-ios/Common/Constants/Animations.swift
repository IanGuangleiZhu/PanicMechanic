//
//  Animations.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/31/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

struct Animations {
    
    static func addRippleEffect(to referenceView: UIView) {
        let scaledWidth = referenceView.bounds.size.width * 1.1
        let scaledHeight = referenceView.bounds.size.height * 1.1
        /*! Creates a circular path around the view*/
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        /*! Position where the shape layer should be */
        let shapePosition = CGPoint(x: referenceView.bounds.size.width / 2.0, y: referenceView.bounds.size.height / 2.0)
        
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
        rippleShape.path = path.cgPath
        let color = UIColor(red: 0.439, green: 0.082, blue: 0.314, alpha: 1.000)
        rippleShape.fillColor = UIColor.clear.cgColor
        rippleShape.strokeColor = color.cgColor
        rippleShape.lineWidth = 8
        rippleShape.position = shapePosition
        rippleShape.opacity = 0
        
        /*! Add the ripple layer as the sublayer of the reference view */
        referenceView.layer.addSublayer(rippleShape)
        /*! Create scale animation of the ripples */
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1))
        /*! Create animation for opacity of the ripples */
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        /*! Group the opacity and scale animations */
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(1.5)
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        rippleShape.add(animation, forKey: "rippleEffect")
    }
    
    static func removeRippleEffect(from referenceView: UIView) {
        if let sublayers = referenceView.layer.sublayers {
            for layer in sublayers {
                if let _ = layer.animation(forKey: "rippleEffect") {
                    layer.removeAnimation(forKey: "rippleEffect")
                }
            }
        }
    }
    
    static func addPulseEffect(to referenceView: UIView) {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.animations = [pulse1]

        referenceView.layer.add(animationGroup, forKey: "pulse")
    }
    
    static func removePulseEffect(from referenceView: UIView) {
        if let sublayers = referenceView.layer.sublayers {
            for layer in sublayers {
                if let _ = layer.animation(forKey: "pulse") {
                    referenceView.layer.removeAnimation(forKey: "pulse")
                }
            }
        }
    }
    
}


