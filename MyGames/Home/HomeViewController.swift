//
//  HomeViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = GameViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var router: AppRouter? // <-- Added router property

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        viewModel.fetchGames()
    }
    
    private func setupViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
    }

    
    private func setupTableView() {
           tableView.translatesAutoresizingMaskIntoConstraints = false
           tableView.dataSource = self
           tableView.delegate = self
           
           // Register custom cell
           tableView.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
           
           // Agar tinggi cell otomatis menyesuaikan konten
           tableView.rowHeight = UITableView.automaticDimension
           tableView.estimatedRowHeight = 100
           
           view.addSubview(tableView)
           
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }

}



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfgames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        
        let game = viewModel.game(at: indexPath.row)
        cell.configure(with: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedGame = viewModel.game(at: indexPath.row)
        router?.navigate(to: Route.gameDetail(gameID: selectedGame.id))
    }
}
