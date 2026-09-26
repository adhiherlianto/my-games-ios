//
//  SearchViewModel.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import Foundation

class SearchViewModel {
    private let service = GameService()
    private(set) var searchResults: [Game] = []
    
    // Timer khusus untuk Debouncing
    private var searchTimer: Timer?
    
    // MARK: - State Management
    private(set) var isLoading: Bool = false
    private(set) var hasSearched: Bool = false
    
    var numberOfResults: Int {
        return searchResults.count
    }
    
    func game(at index: Int) -> Game? {
        guard index >= 0 && index < searchResults.count else { return nil }
        return searchResults[index]
    }
    
    // MARK: - Bindings (Komunikasi ke View Controller)
    var onResultsUpdated: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Search with Debouncing
    /// Dipanggil setiap kali pengguna mengetik satu karakter di SearchBar.
    /// KUNCI DEBOUNCING: Setiap ketukan membatalkan timer sebelumnya.
    /// Request API hanya akan dieksekusi 0.5 detik setelah pengguna BERHENTI mengetik.
    func search(query: String) {
        // 1. Batalkan timer sebelumnya jika user masih terus mengetik
        searchTimer?.invalidate()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Jika kolom pencarian kosong, bersihkan hasil dan jangan tembak API
        guard !trimmedQuery.isEmpty else {
            searchResults = []
            hasSearched = false
            isLoading = false
            onLoading?(false)
            onResultsUpdated?()
            return
        }
        
        // 2. Pasang timer baru berdurasi 0.5 detik (500 ms)
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch(query: trimmedQuery)
        }
    }
    
    /// Menembak API pencarian ke server RAWG
    private func performSearch(query: String) {
        isLoading = true
        hasSearched = true
        onLoading?(true)
        
        service.searchGames(query: query) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            self.onLoading?(false)
            
            switch result {
            case .success(let games):
                self.searchResults = games
                self.onResultsUpdated?()
            case .failure(let error):
                self.onError?("Gagal mencari game: \(error.localizedDescription)")
            }
        }
    }
}
