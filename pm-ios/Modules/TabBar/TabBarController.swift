//
//  TabBarController.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/16/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties -
    var viewModel: TabBarViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    
    // MARK: - Lifecycle -
    
    init(presentables: [Presentable]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = presentables.map { $0.toPresent()! }
        self.setIconImages(titles: ["Home", "History", "Profile"])
//        tabBar.barTintColor = Colors.panicRed
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deallocing \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.start()
        setup()
    }
    
    // MARK: - Private Helpers -
    private func setup() {
        
    }
    
    // MARK: - Public Helpers -
    
    public func setIconImages(titles:[String]) {
        guard let items = self.tabBar.items else { return }
        
        for (index, element) in items.enumerated() {
            element.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            let image = UIImage(named:titles[index])//?.withRenderingMode(.alwaysOriginal)
            element.image = image
        }
    }
    
    public func setSelectedIconImages(titles:[String]) {
        guard let items = self.tabBar.items else { return }
        
        for (index, element) in items.enumerated() {
            element.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            let image = UIImage(named:titles[index])
            element.selectedImage = image
        }
    }
    
    public func setTitles(titles:[String]) {
        guard let items = self.tabBar.items else { return }
        
        for (index, element) in items.enumerated() {
            element.title = titles[index]
        }
    }
    
}

extension TabBarController: TabBarViewModelViewDelegate {
    
}
