//
//  UIViewController+Containment.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Add child view controller to parent.
     - Parameter childViewController: The view controller to be added.
     */
    func add(child childViewController: UIViewController) {
        beginAddChild(child: childViewController)
        view.addSubview(childViewController.view)
        endAddChild(child: childViewController)
    }
    
    /**
    Add child view controller to a specific view.
    - Parameter childViewController: The view controller to be added.
    - Parameter view: The specific view for the child.
    */
    func add(child childViewController: UIViewController, in view: UIView) {
        beginAddChild(child: childViewController)
        view.addSubview(childViewController.view)
        endAddChild(child: childViewController)
    }
    
    /**
    Add child view controller to a specific view with a set frame.
    - Parameter childViewController: The view controller to be added.
    - Parameter view: The specific view for the child.
    - Parameter frame: The frame for the child.
    */
    func add(child childViewController: UIViewController, in view: UIView, with frame:CGRect) {
        beginAddChild(child: childViewController)
        childViewController.view.frame = frame
        view.addSubview(childViewController.view)
        endAddChild(child: childViewController)
    }
    
    /**
    Remove child view controller from parent.
    - Parameter childViewController: The view controller to be removed.
    */
    func remove(child childViewController:UIViewController){
        guard parent != nil else { return }
        childViewController.beginAppearanceTransition(false, animated: false)
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
        childViewController.endAppearanceTransition()
    }
    
    /**
    Helper to start child view controller addition process.
    - Parameter childViewController: The view controller to be removed.
    */
    private func beginAddChild(child childViewController:UIViewController){
        childViewController.beginAppearanceTransition(true, animated: false)
        self.addChild(childViewController)
    }
    
    /**
    Helper to end child view controller addition process.
    - Parameter childViewController: The view controller to be removed.
    */
    private func endAddChild(child childViewController:UIViewController){
        childViewController.didMove(toParent: self)
        childViewController.endAppearanceTransition()
    }
    
}

