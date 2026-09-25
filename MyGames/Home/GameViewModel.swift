//
//  GameViewModel.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//


import Foundation
class GameViewModel {
    private let service = GameService()
    private var games: [Game] = []
    
    var numberOfgames: Int {
        return games.count
    }
    
    func game(at index: Int) -> Game {
        return games[index]
    }
    
    // binding
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    func fetchGames() {
        onLoading?(true)
        service.fetchGames { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let games):
                self.games = games
                self.onSuccess?()
            case .failure(let error):
                self.onError?("Failed to fetch games : \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
