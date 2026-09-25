//
//  TestViewController.swift
//  MyGames
//
//  Created by Muhammad Adhi on 23/09/26.
//

import SnapKit
import UIKit

class TestViewController: UIViewController {

    var bannerImageView: UIImageView = {
        let object = UIImageView()
        object.image = UIImage(named: "bakery")
        object.contentMode = .scaleAspectFit
        object.clipsToBounds = true
        return object
    }()

    var titleLabel: UILabel = {
        let object = UILabel()
        object.text = "Sari Roti Bakery"
        object.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return object
    }()

    var descLabel: UILabel = {
        let object = UILabel()
        object.text = "Silakan pilih roti favorit Anda hari ini." // ✅ Tambahkan teks
        object.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        object.numberOfLines = 0 // Agar teks bisa lebih dari 1 baris
        return object
    }()

    var emailButton: UIButton = {
        let object = UIButton()
        object.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        object.backgroundColor = .systemBlue // ✅ Gunakan warna default jika ColorButton belum ada
        object.setTitleColor(.white, for: .normal)
        object.setTitle("Continue with Email", for: .normal) // ✅ Tambahkan judul
        object.layer.cornerRadius = 8 // Opsional: membuat sudut tombol melengkung
        return object
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI() // ✅ Panggil di viewDidLoad
    }

    func setupUI() {
        self.view.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.width.equalToSuperview().inset(90)
            $0.height.equalTo(200) // ✅ WAJIB: Berikan tinggi yang pasti pada gambar
            $0.centerX.equalToSuperview()
        }

        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bannerImageView.snp.bottom).offset(50)
            $0.left.equalTo(bannerImageView.snp.left)
            $0.right.equalTo(bannerImageView.snp.right)
        }

        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
        }

        self.view.addSubview(emailButton)
        emailButton.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(24)
            $0.width.equalTo(241)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            // $0.bottom.equalToSuperview().inset(64) // ⚠️ Hati-hati menggunakan ini jika konten bisa panjang
        }
    }
}
