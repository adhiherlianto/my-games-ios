//
//  AppRouter.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//
import UIKit

enum Route {
    case gameDetail(gameID: Int)
}

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
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
