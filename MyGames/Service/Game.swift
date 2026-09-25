//
//  Game.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import Foundation

struct Game: Codable {
//    let title: String
//    let releaseDate: String
//    let rating: String
//    let imageName: String
    
    let id: Int
    let name: String
    let released: String
    let rating: Double
    let backgroundImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating
        case backgroundImage = "background_image"
    }
}


