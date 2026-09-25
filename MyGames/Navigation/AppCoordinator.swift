//
//  AppCoordinator.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit

/// Root Coordinator yang memegang kendali navigasi tertinggi di aplikasi.
/// Dipegang langsung oleh SceneDelegate sebagai titik masuk (entry point) aplikasi.
final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        showMainFlow()
    }
    
    /// Menampilkan alur utama aplikasi (Main Tab Bar)
    private func showMainFlow() {
        let tabCoordinator = MainTabCoordinator()
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
        
        // Pasang UITabBarController sebagai root window dan tampilkan
        window.rootViewController = tabCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
