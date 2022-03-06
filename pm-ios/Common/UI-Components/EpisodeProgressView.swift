//
//  EpisodeProgressView.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/15/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class EpisodeProgressView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var progressViews: [UIProgressView] = []
    

    
    init(numProgressBars: Int) {
        super.init(frame: .zero)
        for _ in 0..<numProgressBars {
            let progressView = UIProgressView()
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.tintColor = UIColor(red: 0.44, green: 0.08, blue: 0.31, alpha: 1.0)
            progressView.progress = 0.0
            //            progressView.layer.cornerRadius = 10.0
            //            progressView.layer.masksToBounds = true
            progressViews.append(progressView)
        }
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(stackView)
        let _ = progressViews.map { stackView.addArrangedSubview($0) }
        setupLayout()
    }
    
    private func setupLayout() {
        constrain(stackView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
        }
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize(width: 375, height: 12)
    }
    
    func dropProgressView(at index: Int, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.progressViews[index].isHidden = true
        }, completion: { finished in
//            self.progressViews[index].removeFromSuperview()
//            self.progressViews.remove(at: index)
            completion?()
        })
    }
    
    func setProgress(progress: Float, at index: Int) {
        self.progressViews[index].progress = progress
    }
    
    func resetBars() {
        for progressView in progressViews {
            if !progressView.isHidden {
                progressView.setProgress(0.0, animated: true)
            } else {
                progressView.isHidden = false
                progressView.setProgress(0.0, animated: false)
            }
        }
    }

}
