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
    
    // MARK: - Pagination State
    private(set) var currentPage: Int = 1
    private(set) var isFetching: Bool = false
    private(set) var hasMorePages: Bool = true
    private let pageSize: Int = 10
    
    // MARK: - TableView Helpers
    var numberOfgames: Int {
        return games.count
    }
    
    /// Mengambil game dengan pengecekan index yang aman (mencegah Index out of range crash)
    func game(at index: Int) -> Game? {
        guard index >= 0 && index < games.count else { return nil }
        return games[index]
    }
    
    // MARK: - Bindings
    /// Dipanggil ketika data berhasil diambil dan siap ditampilkan di TableView
    var onSuccess: (() -> Void)?
    
    /// Dipanggil ketika terjadi error dari network
    var onError: ((String) -> Void)?
    
    /// Loading utama (tengah layar) HANYA untuk pengambilan data pertama kali
    var onLoading: ((Bool) -> Void)?
    
    /// Loading kecil (footer tabel) saat user scroll ke bawah memuat halaman berikutnya
    var onPaginationLoading: ((Bool) -> Void)?
    
    // MARK: - Methods
    
    /// Mengambil data awal (halaman 1) saat aplikasi pertama kali dibuka
    func fetchGames() {
        guard !isFetching else { return }
        loadInitialData(isPullToRefresh: false)
    }
    
    /// Dipanggil saat user melakukan pull-to-refresh
    func refreshGames() {
        guard !isFetching else { return }
        loadInitialData(isPullToRefresh: true)
    }
    
    /// Memuat data halaman 1 (baik first load atau pull-to-refresh)
    private func loadInitialData(isPullToRefresh: Bool) {
        isFetching = true
        
        // HANYA aktifkan spinner tengah jika BUKAN pull-to-refresh
        // (Pull-to-refresh sudah memiliki spinner bawaan di atas tabel)
        if !isPullToRefresh {
            onLoading?(true)
        }
        
        service.fetchGames(page: 1, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            
            if !isPullToRefresh {
                self.onLoading?(false)
            }
            
            switch result {
            case .success(let response):
                self.currentPage = 1
                self.hasMorePages = (response.next != nil)
                
                // BEST PRACTICE: Baru perbarui data saat respon SUDAH siap
                // (Jangan hapus data lama sebelum data baru tiba untuk menghindari crash Index Out of Range)
                self.games = response.results
                self.onSuccess?()
                
            case .failure(let error):
                // Jika refresh gagal, data lama tetap utuh di layar
                self.onError?("Failed to fetch games: \(error.localizedDescription)")
            }
        }
    }
    
    /// Mengambil data halaman berikutnya saat user scroll ke bagian bawah tabel (Infinite Scroll)
    func fetchNextPage() {
        // Guard 1: Jangan request jika sedang proses fetch
        guard !isFetching else { return }
        
        // Guard 2: Jangan request jika data sudah habis di server
        guard hasMorePages else { return }
        
        let nextPage = currentPage + 1
        loadNextPageData(page: nextPage)
    }
    
    private func loadNextPageData(page: Int) {
        isFetching = true
        onPaginationLoading?(true)
        
        service.fetchGames(page: page, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            self.onPaginationLoading?(false)
            
            switch result {
            case .success(let response):
                self.currentPage = page
                self.hasMorePages = (response.next != nil)
                
                // Tambahkan data baru ke akhir list (append)
                self.games.append(contentsOf: response.results)
                self.onSuccess?()
                
            case .failure(let error):
                self.onError?("Failed to load more games: \(error.localizedDescription)")
            }
        }
    }
}
