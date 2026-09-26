//
//  SettingTableViewCell.swift
//  MyGames
//
//  Created by Muhammad Adhi on 26/09/26.
//

import UIKit
import SnapKit

/// Model jenis aksi untuk setiap baris pengaturan
enum SettingType {
    case toggle(isOn: Bool, onToggle: (Bool) -> Void)
    case navigation(action: () -> Void)
    case info(value: String)
}

/// Model item baris pengaturan
struct SettingItem {
    let title: String
    let iconName: String
    let iconBackgroundColor: UIColor
    let type: SettingType
}

/// Model seksi kelompok pengaturan
struct SettingSection {
    let title: String
    let items: [SettingItem]
}

/// Custom UITableViewCell bergaya Apple Settings dengan badge ikon warna-warni di sisi kiri
class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    // MARK: - UI Components
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let sc = UISwitch()
        sc.onTintColor = .systemGreen
        sc.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    // Closure untuk menangkap aksi switch
    private var toggleAction: ((Bool) -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupUI() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(switchControl)
    }
    
    private func setupConstraints() {
        // 1. Badge Ikon (Kotak 30x30 pt)
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        // 2. Judul
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(detailLabel.snp.leading).offset(-8)
        }
        
        // 3. Info Kanan
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        // 4. Switch Kanan
        switchControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configuration
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
        iconImageView.image = UIImage(systemName: item.iconName)
        iconContainer.backgroundColor = item.iconBackgroundColor
        
        switch item.type {
        case .toggle(let isOn, let onToggle):
            accessoryType = .none
            selectionStyle = .none
            detailLabel.isHidden = true
            switchControl.isHidden = false
            switchControl.isOn = isOn
            self.toggleAction = onToggle
            
        case .navigation:
            accessoryType = .disclosureIndicator
            selectionStyle = .default
            detailLabel.isHidden = true
            switchControl.isHidden = true
            self.toggleAction = nil
            
        case .info(let value):
            accessoryType = .none
            selectionStyle = .none
            detailLabel.isHidden = false
            detailLabel.text = value
            switchControl.isHidden = true
            self.toggleAction = nil
        }
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        toggleAction?(sender.isOn)
    }
}
