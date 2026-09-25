//
//  MainTabCoordinator.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit

/// Coordinator yang bertanggung jawab mengelola UITabBarController dan tab-tab di dalamnya.
final class MainTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController = UITabBarController(), navigationController: UINavigationController = UINavigationController()) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
    }
    
    func start() {
        // 1. Setup Tab 1: Home (menggunakan HomeCoordinator)
        let homeNavController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        // 2. Setup Tab 2: Bookmark
        let bookmarkVC = BookMarksViewController()
        bookmarkVC.title = "Bookmark"
        bookmarkVC.tabBarItem = UITabBarItem(title: "Bookmark", image: UIImage(systemName: "star"), tag: 1)
        
        // 3. Setup Tab 3: Profile
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        // 4. Setup Tab 4: Test
        let testVC = TestViewController()
        testVC.title = "Test"
        testVC.tabBarItem = UITabBarItem(title: "Test", image: UIImage(systemName: "bell"), tag: 3)
        
        // Konfigurasi TabBar
        tabBarController.viewControllers = [homeNavController, bookmarkVC, profileVC, testVC]
        tabBarController.tabBar.tintColor = .systemGreen
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
    }
}
