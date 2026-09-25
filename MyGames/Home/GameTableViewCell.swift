//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit
import SnapKit
import Kingfisher

class GameTableViewCell: UITableViewCell {
    
    static let identifier = "GameCell"
    
    // MARK: - UI Components
    // 2. Perhatikan: tidak ada lagi "translatesAutoresizingMaskIntoConstraints = false"
    private let gameImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        return label
    }()
    
    // StackView untuk menampung Title & Date
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        // Masukkan title dan date ke dalam stack view
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(dateLabel)
        
        // Tambahkan ke contentView
        contentView.addSubview(gameImage)
        contentView.addSubview(textStackView)
        contentView.addSubview(ratingLabel)
    }
    
    // MARK: - Setup Constraints (Menggunakan SnapKit)
    private func setupConstraints() {
        
        // 1. Game Image
        gameImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(80) // Bisa digabung seperti ini
        }
        
        // 2. Text Stack View (Title + Date)
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(gameImage.snp.trailing).offset(16)
            // KUNCI UTAMANYA: centerY ke gameImage
            make.centerY.equalTo(gameImage)
            // Kanan: tidak boleh menabrak rating label
            make.trailing.lessThanOrEqualTo(ratingLabel.snp.leading).offset(-8)
        }
        
        // 3. Rating Label
        ratingLabel.snp.makeConstraints { make in
            // Menggunakan layoutMarginsGuide agar aman dari accessory view (panah)
            make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
            // Rating juga dibuat di tengah agar seimbang
            make.centerY.equalTo(gameImage)
            make.width.greaterThanOrEqualTo(20)
        }
    }
    
    // MARK: - Configure Cell
    func configure(with game: Game) {
        titleLabel.text = game.name
        dateLabel.text = game.released
        ratingLabel.text = "\(game.rating)"
        
//        gameImage.image = UIImage(systemName: "car.fill")
        let url = URL(string: game.backgroundImage)
        let placeHolder = UIImage(systemName: "photo")
        
        gameImage.kf.setImage(with: url, placeholder: placeHolder, options: [
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ])
        
    }
    
    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        ratingLabel.text = nil
        gameImage.image = nil
    }
}
