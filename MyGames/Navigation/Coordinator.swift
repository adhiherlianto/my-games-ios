//
//  Coordinator.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import UIKit

/// Protokol dasar untuk setiap Coordinator dalam arsitektur Coordinator Pattern.
protocol Coordinator: AnyObject {
    /// Menyimpan referensi child coordinator agar tidak ter-deallocate dari memori saat flow aktif.
    var childCoordinators: [Coordinator] { get set }
    
    /// Navigation controller utama yang dikelola oleh coordinator ini.
    var navigationController: UINavigationController { get set }
    
    /// Titik masuk untuk memulai alur tampilan/navigasi yang dikelola coordinator.
    func start()
}

extension Coordinator {
    /// Menghapus child coordinator dari array ketika flow-nya sudah selesai.
    func removeChild(_ child: Coordinator?) {
        guard let child = child else { return }
        childCoordinators.removeAll { $0 === child }
    }
}
