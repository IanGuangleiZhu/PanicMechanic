//
//  SlideViewController.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class OnboardSlideViewController: BaseViewController {
    
    // MARK: - UI Components -
    private let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.bgColor
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
//        label.font = .boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initializers -
    init(imageName: String?, title: String) {
        super.init()
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        } else {
            imageView.image = nil
        }
        titleLabel.text = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(cardView)
        cardView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        cardView.addSubview(titleLabel)
        layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = imageView.image {
            cardView.backgroundColor = Colors.actionColor
            titleLabel.textColor = Colors.bgColor
        } else {
            cardView.backgroundColor = .clear
            titleLabel.textColor = Colors.panicRed
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }

    private func layoutSubviews() {
        constrain(cardView) { view in
            view.leading == view.superview!.leading + 32.0
            view.trailing == view.superview!.trailing - 32.0
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
        constrain(imageContainer) { view in
            view.width == view.superview!.width * 0.8
            view.height == view.superview!.width * 0.8
            view.top == view.superview!.top + 12.0
            view.centerX == view.superview!.centerX
        }
        constrain(imageView) { view in
            view.height == 100
            view.width == 100
            view.center == view.superview!.center
        }
        constrain(titleLabel, imageView) { view, iV in
            view.leading == view.superview!.leading + 8.0
            view.trailing == view.superview!.trailing - 8.0
            view.top == iV.bottom
            view.bottom == view.superview!.bottom - 12.0
        }
    }
    
}


