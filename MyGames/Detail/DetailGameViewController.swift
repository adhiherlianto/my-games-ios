//
//  DetailGameViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit
import SnapKit
import Kingfisher

class DetailGameViewController: UIViewController {
    
    private let viewModel: DetailGameViewModel
    
    // MARK: - Navigation Bar Items
    private var favoriteButton: UIBarButtonItem?
    private var shareButton: UIBarButtonItem?
    
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
        label.textColor = .label // Otomatis Hitam di Light Mode, Putih di Dark Mode
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let releasedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel // Abu-abu adaptif yang nyaman dibaca
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
        label.textColor = .label // KUNCI: Gunakan .label (Bukan .darkGray) agar otomatis putih di Dark Mode
        label.numberOfLines = 0
        return label
    }()
    
    private let websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Visit Website", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // KUNCI SWIPE TO BACK: Aktifkan kembali interactivePopGestureRecognizer bawaan iOS
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        
        // 1. Tombol Favorite (Heart)
        let initialImageName = viewModel.isFavorite ? "heart.fill" : "heart"
        let favButton = UIBarButtonItem(
            image: UIImage(systemName: initialImageName),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        favButton.tintColor = .systemRed
        self.favoriteButton = favButton
        
        // 2. Tombol Share (square.and.arrow.up)
        let shButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
        shButton.tintColor = .label
        shButton.isEnabled = false // Dinonaktifkan sementara sampai data detail selesai dimuat
        self.shareButton = shButton
        
        // Urutan di iOS: [favoriteButton, shareButton]
        // Hasilnya di navigation bar: Tombol Love di paling kanan ujung, Tombol Share tepat di sebelah kirinya
        navigationItem.rightBarButtonItems = [favButton, shButton]
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteTapped() {
        let isFavorite = viewModel.toggleFavorite()
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton?.image = UIImage(systemName: imageName)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(gameImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releasedLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(websiteButton)
        
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
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
        
        // 6. Description Label
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(releasedLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        // 7. Website Button (di bawah deskripsi & di tengah secara horizontal)
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(48)
            // KUNCI SCROLL VIEW: Bottom harus menempel ke ContentView
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.populateData()
                self?.shareButton?.isEnabled = true
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
        ratingLabel.text = "★ Rating: \(detail.rating)"
        descriptionLabel.text = detail.description
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
        
        // Load gambar menggunakan Kingfisher
        let placeholder = UIImage(systemName: "photo")
        if let url = URL(string: detail.backgroundImage) {
            gameImageView.kf.setImage(with: url, placeholder: placeholder, options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        } else {
            gameImageView.image = placeholder
        }
    }
    
    // MARK: - Actions
    @objc private func websiteButtonTapped() {
        guard let websiteString = viewModel.gameDetail?.website,
              !websiteString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            let alert = UIAlertController(
                title: "Website Tidak Tersedia",
                message: "Game ini tidak memiliki tautan website resmi.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        var formattedUrlString = websiteString.trimmingCharacters(in: .whitespacesAndNewlines)
        if !formattedUrlString.hasPrefix("http://") && !formattedUrlString.hasPrefix("https://") {
            formattedUrlString = "https://" + formattedUrlString
        }
        
        guard let url = URL(string: formattedUrlString) else {
            let alert = UIAlertController(
                title: "Tautan Tidak Valid",
                message: "Format tautan website tidak valid.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func shareTapped() {
        guard let _ = viewModel.gameDetail else { return }
        
        // Kumpulkan paket item lengkap untuk dibagikan (Teks, URL, dan Gambar)
        var itemsToShare: [Any] = []
        
        // 1. Teks informasi game yang informatif
        if let text = viewModel.shareText {
            itemsToShare.append(text)
        }
        
        // 2. Tautan website resmi game atau halaman RAWG
        if let url = viewModel.shareURL {
            itemsToShare.append(url)
        }
        
        // 3. Gambar cover game dari image view (jika sudah dimuat)
        if let image = gameImageView.image, image != UIImage(systemName: "photo") {
            itemsToShare.append(image)
        }
        
        guard !itemsToShare.isEmpty else { return }
        
        // Tampilkan UIActivityViewController (Share Sheet native iOS)
        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        // BEST PRACTICE iOS: Konfigurasi popover presentation controller khusus iPad agar tidak crash
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = shareButton
        }
        
        present(activityViewController, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate (Mengaktifkan Geser Layar / Swipe to Back)
extension DetailGameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Hanya aktifkan swipe back jika memang ada halaman sebelumnya di navigation stack (mencegah bug freeze)
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
