//
//  BookmarkManager.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import Foundation

/// Pengelola penyimpanan lokal game favorit menggunakan UserDefaults.
/// Menggunakan pola Singleton agar data dapat diakses dan diperbarui secara konsisten di seluruh aplikasi.
final class BookmarkManager {
    
    // MARK: - Singleton Instance
    static let shared = BookmarkManager()
    
    // MARK: - Constants
    private let userDefaults = UserDefaults.standard
    private let bookmarkKey = "favorite_games_key"
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Mengambil seluruh daftar game yang disimpan.
    /// Data otomatis terurut dari yang paling baru di-love (indeks 0 adalah yang paling baru).
    func getBookmarks() -> [Game] {
        guard let data = userDefaults.data(forKey: bookmarkKey) else {
            return []
        }
        
        do {
            let games = try JSONDecoder().decode([Game].self, from: data)
            return games
        } catch {
            print("Gagal membaca bookmark dari UserDefaults: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Mengecek apakah game dengan ID tertentu sudah ada di daftar bookmark.
    func isBookmarked(gameId: Int) -> Bool {
        let bookmarks = getBookmarks()
        return bookmarks.contains { $0.id == gameId }
    }
    
    /// Menyimpan game baru ke bookmark.
    /// KUNCI URUTAN: Menggunakan `insert(game, at: 0)` agar game yang baru disukai selalu berada di paling atas.
    func addBookmark(game: Game) {
        var bookmarks = getBookmarks()
        
        // Hapus terlebih dahulu jika sebelumnya sudah pernah ada (mencegah duplikasi data)
        bookmarks.removeAll { $0.id == game.id }
        
        // Selipkan di posisi paling awal
        bookmarks.insert(game, at: 0)
        
        save(bookmarks: bookmarks)
    }
    
    /// Menghapus game dari daftar bookmark berdasarkan ID.
    func removeBookmark(gameId: Int) {
        var bookmarks = getBookmarks()
        bookmarks.removeAll { $0.id == gameId }
        save(bookmarks: bookmarks)
    }
    
    /// Menghapus seluruh data game favorit dari bookmark.
    func clearAllBookmarks() {
        userDefaults.removeObject(forKey: bookmarkKey)
    }
    
    /// Fungsi praktis untuk toggle:
    /// - Jika sudah ada di bookmark -> Hapus.
    /// - Jika belum ada di bookmark -> Simpan.
    /// Mengembalikan nilai `true` jika status barunya menjadi favorit, atau `false` jika dihapus.
    @discardableResult
    func toggleBookmark(game: Game) -> Bool {
        if isBookmarked(gameId: game.id) {
            removeBookmark(gameId: game.id)
            return false
        } else {
            addBookmark(game: game)
            return true
        }
    }
    
    // MARK: - Private Persistence Helper
    private func save(bookmarks: [Game]) {
        do {
            let data = try JSONEncoder().encode(bookmarks)
            userDefaults.set(data, forKey: bookmarkKey)
        } catch {
            print("Gagal menyimpan bookmark ke UserDefaults: \(error.localizedDescription)")
        }
    }
}
