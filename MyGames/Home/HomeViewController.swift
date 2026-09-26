//
//  HomeViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Cari game favoritmu..."
        sb.searchBarStyle = .minimal
        return sb
    }()
    private let searchOverlayButton = UIButton(type: .custom)
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    private let viewModel = GameViewModel()
    weak var coordinator: HomeNavigationDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.fetchGames()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Agar tombol Back di halaman berikutnya rapi (hanya chevron tanpa tulisan panjang)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // 1. Setup Search Bar (Pemicu untuk pindah ke SearchViewController)
        searchOverlayButton.addTarget(self, action: #selector(handleSearchTapped), for: .touchUpInside)
        
        view.addSubview(searchBar)
        view.addSubview(searchOverlayButton)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        searchOverlayButton.snp.makeConstraints { make in
            make.edges.equalTo(searchBar)
        }
        
        // 2. Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        // 3. Setup Pull-to-Refresh
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 4. Setup Spinner Tengah (Initial Loading)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func handleSearchTapped() {
        coordinator?.goToSearch()
    }
    
    // MARK: - Setup ViewModel Bindings
    private func setupViewModel() {
        // Data sukses dimuat
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
        // Error handling
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
        
        // Loading awal (tengah layar)
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
        
        // Loading pagination (spinner kecil di bagian footer tabel)
        viewModel.onPaginationLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.tableView.tableFooterView = self?.createFooterSpinner()
                } else {
                    self?.tableView.tableFooterView = nil
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    /// Membuat tampilan footer tabel yang berisi UIActivityIndicatorView kecil
    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        footerView.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return footerView
    }
    
    @objc private func handleRefresh() {
        viewModel.refreshGames()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfgames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        
        if let game = viewModel.game(at: indexPath.row) {
            cell.configure(with: game)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedGame = viewModel.game(at: indexPath.row) else { return }
        coordinator?.showGameDetail(gameId: selectedGame.id)
    }
    
    /// KUNCI INFINITE SCROLL:
    /// Mendeteksi saat cell akan ditampilkan. Jika cell yang akan tampil adalah baris terakhir,
    /// minta ViewModel untuk memuat halaman berikutnya.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = (indexPath.row == viewModel.numberOfgames - 1)
        if isLastCell {
            viewModel.fetchNextPage()
        }
    }
}
