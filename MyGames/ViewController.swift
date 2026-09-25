//
//  ViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // create instance of view controller
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        
        let bookmarkVC = BookMarksViewController()
        bookmarkVC.title = "Bookmark"
        
        let testVC = TestViewController()
        testVC.title = "Test"
        
        // assign viewcontroller to tabbar
        self.setViewControllers([homeVC,  bookmarkVC, profileVC, testVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "star", "person", "bell"]
        
        for x in 0..<images.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        self.tabBar.tintColor = .systemGreen
        self.tabBar.unselectedItemTintColor = .systemGray
        
        
    }


}

