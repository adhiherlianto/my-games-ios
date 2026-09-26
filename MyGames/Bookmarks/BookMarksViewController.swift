//
//  BookMarksViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import UIKit
import SnapKit

class BookMarksViewController: UIViewController {

    // MARK: - UI Components
    private let tableView = UITableView()
    
    // View khusus untuk Empty State (saat belum ada game favorit)
    private let emptyStateView = UIView()
    private let emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart.slash")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Belum Ada Game Favorit"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Game yang kamu beri tanda love pada halaman detail akan muncul di sini."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Data Source
    private var favoriteGames: [Game] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// KUNCI AUTO-REFRESH:
    /// Setiap kali pengguna berpindah ke tab Bookmark, `viewWillAppear` akan dipanggil,
    /// sehingga daftar game favorit langsung terbarui dengan data terkini dari UserDefaults.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Bookmark"
        
        // 1. Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 2. Setup Empty State View
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Data Loading
    private func loadBookmarks() {
        // Ambil data terbaru dari BookmarkManager (sudah terurut dari yang paling baru di-love)
        favoriteGames = BookmarkManager.shared.getBookmarks()
        updateVisibility()
        tableView.reloadData()
    }
    
    private func updateVisibility() {
        let isEmpty = favoriteGames.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BookMarksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        
        let game = favoriteGames[indexPath.row]
        cell.configure(with: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedGame = favoriteGames[indexPath.row]
        let detailVM = DetailGameViewModel(gameId: selectedGame.id)
        let detailVC = DetailGameViewController(viewModel: detailVM)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // FITUR TAMBAHAN: Geser (Swipe) ke kiri untuk menghapus dari Bookmark secara langsung
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = favoriteGames[indexPath.row]
            BookmarkManager.shared.removeBookmark(gameId: game.id)
            favoriteGames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateVisibility()
        }
    }
}
