//
//  SettingsViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import UIKit
import SnapKit
import Kingfisher

class SettingsViewController: UIViewController {

    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Data Source
    private var sections: [SettingSection] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data seksi (misal jika status Dark Mode berubah)
        setupSections()
        tableView.reloadData()
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = 48
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Build Setting Sections
    private func setupSections() {
        // Section 1: Tampilan & Preferensi
        let appearanceSection = SettingSection(
            title: "TAMPILAN & PREFERENSI",
            items: [
                SettingItem(
                    title: "Mode Gelap",
                    iconName: "moon.fill",
                    iconBackgroundColor: .systemIndigo,
                    type: .toggle(isOn: ThemeManager.shared.isDarkMode, onToggle: { [weak self] isDark in
                        ThemeManager.shared.setDarkMode(isDark)
                        self?.setupSections()
                    })
                ),
                SettingItem(
                    title: "Notifikasi Game Baru",
                    iconName: "bell.badge.fill",
                    iconBackgroundColor: .systemRed,
                    type: .toggle(isOn: true, onToggle: { _ in })
                )
            ]
        )
        
        // Section 2: Penyimpanan & Data
        let storageSection = SettingSection(
            title: "PENYIMPANAN & DATA",
            items: [
                SettingItem(
                    title: "Bersihkan Cache Gambar",
                    iconName: "sparkles",
                    iconBackgroundColor: .systemOrange,
                    type: .navigation(action: { [weak self] in
                        self?.handleClearImageCache()
                    })
                ),
                SettingItem(
                    title: "Hapus Semua Bookmark",
                    iconName: "heart.slash.fill",
                    iconBackgroundColor: .systemPink,
                    type: .navigation(action: { [weak self] in
                        self?.handleClearAllBookmarks()
                    })
                )
            ]
        )
        
        // Section 3: Tentang & Sumber Data
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let aboutSection = SettingSection(
            title: "TENTANG & SUMBER DATA",
            items: [
                SettingItem(
                    title: "Sumber Data RAWG",
                    iconName: "globe",
                    iconBackgroundColor: .systemGreen,
                    type: .navigation(action: { [weak self] in
                        self?.openURL("https://rawg.io")
                    })
                ),
                SettingItem(
                    title: "Versi Aplikasi",
                    iconName: "info.circle.fill",
                    iconBackgroundColor: .systemGray,
                    type: .info(value: "v\(appVersion)")
                )
            ]
        )
        
        // Section 4: Bantuan & Masukan
        let feedbackSection = SettingSection(
            title: "DUKUNGAN",
            items: [
                SettingItem(
                    title: "Kirim Masukan",
                    iconName: "envelope.fill",
                    iconBackgroundColor: .systemTeal,
                    type: .navigation(action: { [weak self] in
                        self?.handleSendFeedback()
                    })
                )
            ]
        )
        
        sections = [appearanceSection, storageSection, aboutSection, feedbackSection]
    }

    // MARK: - Actions
    private func handleClearImageCache() {
        ImageCache.default.clearDiskCache { [weak self] in
            ImageCache.default.clearMemoryCache()
            
            let alert = UIAlertController(
                title: "Cache Dibersihkan",
                message: "Seluruh cache gambar telah berhasil dibersihkan dari penyimpanan perangkat.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func handleClearAllBookmarks() {
        let alert = UIAlertController(
            title: "Hapus Semua Bookmark",
            message: "Apakah kamu yakin ingin menghapus seluruh game favorit dari penyimpanan? Tindakan ini tidak dapat dibatalkan.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Hapus Semua", style: .destructive, handler: { [weak self] _ in
            BookmarkManager.shared.clearAllBookmarks()
            
            let infoAlert = UIAlertController(
                title: "Berhasil",
                message: "Semua game favorit telah dihapus.",
                preferredStyle: .alert
            )
            infoAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(infoAlert, animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    private func handleSendFeedback() {
        let email = "herlianto.adhi@gmail.com"
        
        // Gunakan URLComponents agar subjek dan isi pesan otomatis di-encode dengan aman
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        components.queryItems = [
            URLQueryItem(name: "subject", value: "Konsultasi - MyGames App"),
            URLQueryItem(name: "body", value: "hallo saya ingin berkonsultasi")
        ]
        
        guard let url = components.url else { return }
        
        // Langsung buka aplikasi Email default tanpa memunculkan popup alert
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.row]
        if case .navigation(let action) = item.type {
            action()
        }
    }
}
