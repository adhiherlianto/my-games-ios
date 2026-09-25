//
//  AppRouter.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit

@available(*, deprecated, message: "Gunakan HomeCoordinator sesuai arsitektur Coordinator Pattern")
enum Route {
    case gameDetail(gameID: Int)
}

@available(*, deprecated, message: "Gunakan AppCoordinator & HomeCoordinator sesuai arsitektur Coordinator Pattern")
class AppRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to route: Route) {
        switch route {
        case .gameDetail(let gameID):
            let viewModel = DetailGameViewModel(gameId: gameID)
            let viewController = DetailGameViewController(viewModel: viewModel)
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
