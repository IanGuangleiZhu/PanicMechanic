//
//  ProfileAvatarTableViewCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 2/1/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import UIKit
import Cartography

class ProfileAvatarTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let avatar: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Colors.bgColor
        imageView.image = UIImage(named: "LogoGray")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.bgColor
        label.font = UIFont(name: "SFCompactRounded-Semibold", size: 24.0)
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.bgColor
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 16.0)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.bgColor
        label.font = UIFont(name: "SFCompactRounded-Regular", size: 16.0)
        return label
    }()
    
    
    static var standardHeight: Double {
        return 280.0
    }
    
    static var reuseIdentifier: String {
        return "profileAvatar.cell"
    }
    

    func configure(with viewModel: ProfileAvatarTableViewCellViewModel?) {
        nameLabel.text = viewModel?.name
        genderLabel.text = viewModel?.gender
        if let age = viewModel?.age {
            if age == -1 {
                ageLabel.text = "Unknown Age"
            } else {
                ageLabel.text = "\(age)"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(spacer)
        contentView.addSubview(genderLabel)
        contentView.addSubview(ageLabel)
        constrain(avatar) { view in
            view.top == view.superview!.top + 24.0
            view.centerX == view.superview!.centerX
            view.height == 150
            view.width == 150
        }
        constrain(nameLabel, avatar) { view, a in
            view.centerX == a.centerX
            view.top == a.bottom + 16.0
        }
        
        constrain(spacer, nameLabel) { view, nL in
            view.width == 1
            view.height == 25
            view.centerX == nL.centerX
            view.top == nL.bottom + 16.0
        }
        constrain(genderLabel, spacer) { view, s in
            view.trailing == s.leading - 8.0
            view.centerY == s.centerY
        }
        constrain(ageLabel, spacer) { view, s in
            view.leading == s.trailing + 8.0
            view.centerY == s.centerY
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
//        avatar.image = nil
        nameLabel.text = nil
    }
    
}

struct ProfileAvatarCell {
    
    let user: PanicMechanicUser

    init(user: PanicMechanicUser) {
        self.user = user
    }
    
}

extension ProfileAvatarCell : ProfileAvatarTableViewCellViewModel {
    
    var name: String {
        return user.nickname ?? "Anonymous Mechanic"
    }

    var gender: String {
        return user.gender.rawValue
    }

    var age: Int {
        return user.age
    }

}

extension ProfileAvatarCell : TableViewItemViewModel {
    
    var height: Double {
        return ProfileAvatarTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return ProfileAvatarTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

protocol ProfileAvatarTableViewCellViewModel {
    var name: String { get }
    var gender: String { get }
    var age: Int { get }
}

