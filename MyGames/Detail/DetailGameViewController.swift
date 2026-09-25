//
//  DetailGameViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit
import SnapKit

class DetailGameViewController: UIViewController {
    
    private let viewModel: DetailGameViewModel
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let gameImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let releasedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    init(viewModel: DetailGameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupViewModel()
        
        // Panggil API (yang akan kamu isi nanti)
        viewModel.fetchDetail()
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // Tombol Back
        let backImage = UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        // Tombol Favorite (Heart)
        let heartImage = UIImage(systemName: "heart.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: heartImage,
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteTapped() {
        print("Favorite tapped for game ID")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(gameImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releasedLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    // MARK: - Setup Constraints (SNAPKIT)
    private func setupConstraints() {
        // 1. ScrollView & ContentView
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // KUNCI SCROLL VIEW: ContentView harus sama lebarnya dengan ScrollView
            make.width.equalTo(scrollView)
        }
        
        // 2. Hero Image (Full Width, Height 220)
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        // 3. Title Label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // 4. Released Label (Kiri Bawah Title)
        releasedLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(titleLabel)
        }
        
        // 5. Rating Label (Kanan Bawah Title, sejajar dengan Released)
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(releasedLabel)
            make.trailing.equalTo(titleLabel)
            make.leading.greaterThanOrEqualTo(releasedLabel.snp.trailing).offset(8)
        }
        
        // 6. Description Label (Paling Bawah)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(releasedLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(titleLabel)
            // KUNCI SCROLL VIEW: Bottom harus menempel ke ContentView
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.populateData()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    private func populateData() {
        guard let detail = viewModel.gameDetail else { return }
        
        titleLabel.text = detail.name
        releasedLabel.text = "Released Date: \(detail.released)"
        ratingLabel.text = "Rating: \(detail.rating)"
        descriptionLabel.text = detail.description
        
        // Load gambar (menggunakan extension yang kita buat sebelumnya)
        let placeholder = UIImage(systemName: "photo")
        gameImageView.image = placeholder
        // gameImageView.loadImage(from: detail.backgroundImage, placeholder: placeholder)
    }
}
