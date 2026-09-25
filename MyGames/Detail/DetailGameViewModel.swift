//
//  DetailGameViewModel.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import Foundation

class DetailGameViewModel {
    private let gameID: Int
    private let service = GameService()
    
    // binding
    var onSuccess:(() -> Void)?
    var onError:((String) -> Void)?
    
    private(set) var gameDetail: GameDetail?
    
    init(gameId: Int) {
        self.gameID = gameId
    }
    
    func fetchDetail() {
        service.fetchDetailGame(id: gameID) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.gameDetail = detail
                self?.onSuccess?()
            case .failure(let error):
                self?.onError?("Gagal Memuat Detail \(error.localizedDescription)")
            }
        }
    }
}
