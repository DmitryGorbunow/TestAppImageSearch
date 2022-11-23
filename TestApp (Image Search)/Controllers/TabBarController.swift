//
//  TabBarController.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/23/22.
//

import UIKit

enum Tabs: Int {
    case imageSearch
    case settings
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        
        let searchController = SearchController()
        let settingsController = SettingsController()
        
        let searchNavigation = NavBarController(rootViewController: searchController)
        let settingsNavigation = NavBarController(rootViewController: settingsController)
        
        searchController.tabBarItem = UITabBarItem(title: "Image Search", image: UIImage(systemName: "magnifyingglass"), tag: Tabs.imageSearch.rawValue)
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: Tabs.settings.rawValue)
        
        setViewControllers([
            searchNavigation,
            settingsNavigation
        ], animated: false)
    }
    
}
