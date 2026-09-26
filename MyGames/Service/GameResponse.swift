//
//  GameResponse.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

struct GameResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}
