//
//  SearchViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: SearchViewModel
    weak var coordinator: HomeNavigationDelegate?
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Cari judul game..."
        sb.searchBarStyle = .minimal
        sb.autocapitalizationType = .none
        sb.autocorrectionType = .no
        sb.showsCancelButton = true
        sb.tintColor = .systemGreen
        return sb
    }()
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // 1. Tampilan Awal (Sebelum Mengetik)
    private let initialStateView = UIView()
    private let initialIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let initialLabel: UILabel = {
        let label = UILabel()
        label.text = "Ketik judul game untuk mulai mencari"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // 2. Tampilan Kosong (Hasil Tidak Ditemukan)
    private let emptyResultView = UIView()
    private let emptyIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "exclamationmark.magnifyingglass"))
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Game tidak ditemukan\nCoba kata kunci yang lain"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // KUNCI UX: Otomatis munculkan keyboard begitu halaman terbuka
        searchBar.becomeFirstResponder()
        
        // Aktifkan swipe-to-back
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Pasang searchBar langsung ke navigation bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        // Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(tableView)
        view.addSubview(initialStateView)
        view.addSubview(emptyResultView)
        view.addSubview(activityIndicator)
        
        // Setup Initial State View
        initialStateView.addSubview(initialIcon)
        initialStateView.addSubview(initialLabel)
        
        // Setup Empty Result View
        emptyResultView.addSubview(emptyIcon)
        emptyResultView.addSubview(emptyLabel)
        emptyResultView.isHidden = true
        
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - Setup Constraints (SnapKit)
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Initial State Container
        initialStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        initialIcon.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        initialLabel.snp.makeConstraints { make in
            make.top.equalTo(initialIcon.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Empty Result Container
        emptyResultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        emptyIcon.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyIcon.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Setup ViewModel Bindings
    private func setupViewModel() {
        // 1. Loading State
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.initialStateView.isHidden = true
                    self?.emptyResultView.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        // 2. Results Updated
        viewModel.onResultsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let hasResults = self.viewModel.numberOfResults > 0
                let hasSearched = self.viewModel.hasSearched
                
                self.tableView.isHidden = !hasResults
                self.initialStateView.isHidden = hasSearched
                self.emptyResultView.isHidden = !hasSearched || hasResults
                
                self.tableView.reloadData()
            }
        }
        
        // 3. Error State
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Pencarian Gagal", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
}

// MARK: - UISearchBarDelegate (Mendeteksi Ketukan Keyboard)
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Panggil fungsi search dengan Debouncing di ViewModel
        viewModel.search(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfResults
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
        searchBar.resignFirstResponder()
        
        guard let selectedGame = viewModel.game(at: indexPath.row) else { return }
        // Buka halaman detail game melalui coordinator
        coordinator?.showGameDetail(gameId: selectedGame.id)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Tutup keyboard saat user mulai menggulir hasil pencarian
        searchBar.resignFirstResponder()
    }
}

// MARK: - UIGestureRecognizerDelegate (Swipe to Back)
extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
