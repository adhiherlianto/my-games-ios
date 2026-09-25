//
//  GameDetail.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import Foundation
struct GameDetail: Codable {
    let id: Int
    let name: String
    let description: String
    let rating: Double
    let backgroundImage: String
    let website: String
    let released: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, rating, website, released
        case backgroundImage = "background_image"
    }
}
