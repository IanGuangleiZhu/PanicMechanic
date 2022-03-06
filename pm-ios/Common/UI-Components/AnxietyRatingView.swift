//
//  AnxietyRatingView.swift
//  pm-ios
//
//  Created by Synbrix Software on 10/15/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

// SOURCE: https://blog.usejournal.com/custom-uiview-in-swift-done-right-ddfe2c3080a
class AnxietyRatingView: UIView {
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rate Your Anxiety"
        label.textAlignment = .center
        label.font = UIFont(name: "11S01 Black Tuesday", size: 32.0)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 5
        slider.tintColor = Colors.opaquePink
        return slider
    }()

    lazy var addButton: UIButton = {
      let addButton = UIButton(type: .contactAdd)
      addButton.translatesAutoresizingMaskIntoConstraints = false
      return addButton
    }()
    
    lazy var contentView: UIImageView = {
      let contentView = UIImageView()
      contentView.image = UIImage(named: "WoodTexture")
      contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
      return contentView
    }()
    
    lazy var headerTitle: UILabel = {
      let headerTitle = UILabel()
      headerTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)
      headerTitle.text = "Custom View"
      headerTitle.textAlignment = .center
      headerTitle.translatesAutoresizingMaskIntoConstraints = false
      return headerTitle
    }()
    
    lazy var headerView: UIView = {
      let headerView = UIView()
      headerView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
      headerView.layer.shadowColor = UIColor.gray.cgColor
      headerView.layer.shadowOffset = CGSize(width: 0, height: 10)
      headerView.layer.shadowOpacity = 1
      headerView.layer.shadowRadius = 5
      headerView.addSubview(headerTitle)
      headerView.addSubview(addButton)
      headerView.translatesAutoresizingMaskIntoConstraints = false
      return headerView
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
        addSubview(instructionsLabel)
        addSubview(ratingSlider)
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        constrain(instructionsLabel) { view in
            view.top == view.superview!.top
            view.centerX == view.superview!.centerX
        }
        constrain(ratingSlider, instructionsLabel) { view, iL in
            view.top == iL.bottom + 32.0
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
      return CGSize(width: 300, height: 240)
    }
    
    //we add a top constraint property
    private var headerViewTop: NSLayoutConstraint!

    private func setupActions() {
      addButton.addTarget(self, action: #selector(moveHeaderView), for: .touchUpInside)
    }

    @objc private func moveHeaderView() {
      //here we have 2 ways to modify the constraint

      //first one (easier & preffered)
      //manual trigger layout cycle
      headerViewTop.constant += 10
      setNeedsLayout()

      //second one (use for performance boost)
      headerViewTopConstant += 10
    }

    //introduce a new variable for updateConstraints logic
    private var headerViewTopConstant: CGFloat = 0 {
      didSet {
        //manual trigger layout cycle, but here
        //we will set the constant inside updateConstraints
        setNeedsUpdateConstraints()
      }
    }

    override func updateConstraints() {
//      headerViewTop.constant = headerViewTopConstant
      super.updateConstraints()
    }

}
