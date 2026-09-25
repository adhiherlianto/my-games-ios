//
//  HomeCoordinator.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit

/// Protocol delegate untuk komunikasi navigasi dari HomeViewController ke HomeCoordinator.
/// HomeViewController tidak perlu tahu siapa yang menangani navigasinya.
protocol HomeNavigationDelegate: AnyObject {
    func showGameDetail(gameId: Int)
}

/// Coordinator yang bertanggung jawab atas seluruh navigasi di dalam tab Home.
final class HomeCoordinator: Coordinator, HomeNavigationDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // Injeksi coordinator sebagai delegate navigasi HomeViewController
        homeVC.coordinator = self
        
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    // MARK: - Navigation Actions
    func showGameDetail(gameId: Int) {
        let viewModel = DetailGameViewModel(gameId: gameId)
        let detailVC = DetailGameViewController(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
