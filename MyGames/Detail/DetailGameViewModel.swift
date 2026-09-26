//
//  DetailGameViewModel.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import Foundation

class DetailGameViewModel {
    let gameID: Int
    private let service = GameService()
    
    // MARK: - Bindings
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var gameDetail: GameDetail?
    
    // MARK: - Favorite State
    /// Mengecek apakah game ini sudah ada di bookmark
    var isFavorite: Bool {
        return BookmarkManager.shared.isBookmarked(gameId: gameID)
    }
    
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
                self?.onError?("Gagal Memuat Detail: \(error.localizedDescription)")
            }
        }
    }
    
    /// Mengubah status bookmark game ini (Tambah jika belum ada, Hapus jika sudah ada)
    /// Mengembalikan status terbaru: `true` jika menjadi favorit, `false` jika dihapus.
    @discardableResult
    func toggleFavorite() -> Bool {
        guard let detail = gameDetail else {
            // Jika data detail belum selesai di-fetch, kembalikan status saat ini
            return isFavorite
        }
        
        let game = Game(
            id: detail.id,
            name: detail.name,
            released: detail.released,
            rating: detail.rating,
            backgroundImage: detail.backgroundImage
        )
        return BookmarkManager.shared.toggleBookmark(game: game)
    }
    
    // MARK: - Share Helpers
    /// Format teks yang rapi dan informatif untuk dibagikan
    var shareText: String? {
        guard let detail = gameDetail else { return nil }
        return """
        🎮 Cek game seru ini: \(detail.name)
        ⭐ Rating: \(detail.rating) / 5.0
        📅 Tanggal Rilis: \(detail.released)
        """
    }
    
    /// URL resmi game atau link RAWG sebagai tautan yang valid
    var shareURL: URL? {
        guard let detail = gameDetail else { return nil }
        var trimmedWebsite = detail.website.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedWebsite.isEmpty {
            if !trimmedWebsite.hasPrefix("http://") && !trimmedWebsite.hasPrefix("https://") {
                trimmedWebsite = "https://" + trimmedWebsite
            }
            if let url = URL(string: trimmedWebsite) {
                return url
            }
        }
        return URL(string: "https://rawg.io/games/\(detail.id)")
    }
}
