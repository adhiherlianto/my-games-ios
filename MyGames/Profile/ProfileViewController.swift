//
//  ProfileViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 1. Header Profil (Foto, Nama, Role, Headline)
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        // Menggunakan SF Symbol bawaan iOS yang elegan sebagai default
        let config = UIImage.SymbolConfiguration(pointSize: 55, weight: .light)
        iv.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        iv.tintColor = .systemGreen
        iv.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 55
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.systemGreen.cgColor
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Muhammad Adhi"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Passionate about crafting clean, modular, and responsive iOS apps using Swift & UIKit."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // 2. Tombol Aksi GitHub
    private let githubButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Kunjungi Profil GitHub", for: .normal)
        button.setImage(UIImage(systemName: "link.circle.fill"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Menggunakan systemGroupedBackground agar otomatis cocok dengan tema kartu Apple
        view.backgroundColor = .systemGroupedBackground
        title = "Profile"
        
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        
        // Tambahkan elemen Header ke contentView
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(headlineLabel)
        
        // Aksi tombol
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Constraints (SnapKit)
    private func setupConstraints() {
        // 1. ScrollView & ContentView
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // KUNCI: Lebar contentView harus sama dengan scrollView agar hanya bisa scroll vertikal
            make.width.equalTo(scrollView)
        }
        
        // 2. Avatar Profil
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(110)
        }
        
        // 3. Nama
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // 4. Role
        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // 5. Headline / Motto
        headlineLabel.snp.makeConstraints { make in
            make.top.equalTo(roleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        // 6. Kartu 1: Informasi Pribadi
        let personalInfoCard = createPersonalInfoCard()
        contentView.addSubview(personalInfoCard)
        personalInfoCard.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 7. Kartu 2: Tentang Pengembang (About)
        let aboutCard = createAboutCard()
        contentView.addSubview(aboutCard)
        aboutCard.snp.makeConstraints { make in
            make.top.equalTo(personalInfoCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 8. Kartu 3: Keahlian & Teknologi (Tech Stack)
        let skillsCard = createSkillsCard()
        contentView.addSubview(skillsCard)
        skillsCard.snp.makeConstraints { make in
            make.top.equalTo(aboutCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 9. Tombol GitHub (Elemen Paling Bawah)
        contentView.addSubview(githubButton)
        githubButton.snp.makeConstraints { make in
            make.top.equalTo(skillsCard.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            // KUNCI SCROLLVIEW: Batas bawah elemen terakhir harus menempel ke contentView
            make.bottom.equalToSuperview().offset(-36)
        }
    }
    
    // MARK: - Card Component Builders
    
    /// Membuat kartu template dengan sudut melengkung dan warna latar adaptif
    private func createCardView() -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.clipsToBounds = true
        return card
    }
    
    /// Header judul kecil di dalam setiap kartu
    private func createCardHeader(iconName: String, title: String) -> UIStackView {
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = .systemGreen
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { $0.width.height.equalTo(18) }
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        
        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }
    
    /// Garis pemisah tipis (*Divider*) antar baris
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .separator.withAlphaComponent(0.4)
        divider.snp.makeConstraints { $0.height.equalTo(0.5) }
        return divider
    }
    
    /// 1. Builder Kartu Informasi Pribadi
    private func createPersonalInfoCard() -> UIView {
        let card = createCardView()
        
        let header = createCardHeader(iconName: "person.text.rectangle.fill", title: "Informasi Pribadi")
        
        // Baris data dummy
        let birthRow = createInfoRow(iconName: "calendar", title: "Tanggal Lahir", value: "23 September 1998")
        let locationRow = createInfoRow(iconName: "mappin.and.ellipse", title: "Alamat", value: "Jakarta, Indonesia")
        let emailRow = createInfoRow(iconName: "envelope.fill", title: "Email", value: "herlianto.adhi@gmail.com")
        let statusRow = createInfoRow(iconName: "briefcase.fill", title: "Status", value: "Open for Opportunities")
        
        let stack = UIStackView(arrangedSubviews: [
            header,
            createDivider(),
            birthRow,
            createDivider(),
            locationRow,
            createDivider(),
            emailRow,
            createDivider(),
            statusRow
        ])
        stack.axis = .vertical
        stack.spacing = 12
        
        card.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return card
    }
    
    /// Baris tunggal informasi: Ikon + Judul + Nilai
    private func createInfoRow(iconName: String, title: String, value: String) -> UIView {
        let container = UIView()
        
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right
        
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return container
    }
    
    /// 2. Builder Kartu Tentang Pengembang
    private func createAboutCard() -> UIView {
        let card = createCardView()
        
        let header = createCardHeader(iconName: "text.quote", title: "Tentang Pengembang")
        
        let bioLabel = UILabel()
        bioLabel.text = "Halo! Saya Muhammad Adhi, pengembang di balik aplikasi MyGames. Memiliki antusiasme tinggi terhadap ekosistem Apple, clean architecture (MVVM & Coordinator), serta penulisan kode Auto Layout murni dengan SnapKit."
        bioLabel.font = .systemFont(ofSize: 14, weight: .regular)
        bioLabel.textColor = .label
        bioLabel.numberOfLines = 0
        bioLabel.lineBreakMode = .byWordWrapping
        
        let stack = UIStackView(arrangedSubviews: [header, createDivider(), bioLabel])
        stack.axis = .vertical
        stack.spacing = 12
        
        card.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return card
    }
    
    /// 3. Builder Kartu Keahlian & Teknologi
    private func createSkillsCard() -> UIView {
        let card = createCardView()
        
        let header = createCardHeader(iconName: "chevron.left.forwardslash.chevron.right", title: "Keahlian & Teknologi")
        
        // Baris badge 1
        let badgeRow1 = UIStackView(arrangedSubviews: [
            createSkillBadge(text: "Swift"),
            createSkillBadge(text: "UIKit"),
            createSkillBadge(text: "SnapKit"),
            createSkillBadge(text: "MVVM")
        ])
        badgeRow1.axis = .horizontal
        badgeRow1.spacing = 8
        badgeRow1.distribution = .fillProportionally
        
        // Baris badge 2
        let badgeRow2 = UIStackView(arrangedSubviews: [
            createSkillBadge(text: "Coordinator"),
            createSkillBadge(text: "UserDefaults"),
            createSkillBadge(text: "REST API")
        ])
        badgeRow2.axis = .horizontal
        badgeRow2.spacing = 8
        badgeRow2.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [header, createDivider(), badgeRow1, badgeRow2])
        stack.axis = .vertical
        stack.spacing = 12
        
        card.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return card
    }
    
    /// Badge kecil untuk menandai skill / teknologi
    private func createSkillBadge(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        
        let container = UIView()
        container.backgroundColor = .systemGreen.withAlphaComponent(0.12)
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        return container
    }
    
    // MARK: - Actions
    @objc private func githubButtonTapped() {
        guard let url = URL(string: "https://github.com/adhiherlianto") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
