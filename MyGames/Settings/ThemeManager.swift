//
//  ThemeManager.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import UIKit

/// Pengelola tema aplikasi (Dark Mode / Light Mode).
/// Mengontrol pengaturan mode antarmuka secara global dan menyimpannya di UserDefaults.
final class ThemeManager {
    
    static let shared = ThemeManager()
    
    private let themeKey = "is_dark_mode_key"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    /// Mengembalikan true jika pengguna memilih Dark Mode
    var isDarkMode: Bool {
        return userDefaults.bool(forKey: themeKey)
    }
    
    /// Mengubah tema, menyimpannya ke UserDefaults, dan langsung menerapkan perubahan ke seluruh layar aplikasi
    func setDarkMode(_ isDark: Bool) {
        userDefaults.set(isDark, forKey: themeKey)
        applyTheme()
    }
    
    /// Menerapkan tema yang tersimpan ke seluruh window aplikasi dengan animasi cross-dissolve yang halus
    func applyTheme() {
        let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = style
                }, completion: nil)
            }
    }
}
