//
//  GameService.swift
//  MyGames
//
//  Created by Muhammad Adhi on 25/09/26.
//

import Foundation

class GameService {
    static let shared = GameService()
    
    
    func fetchGames(completion: @escaping(Result<[Game], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "https://api.rawg.io/api/games")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: "1ab9d933688b43f6bae9b55c65ddb85c"),
            URLQueryItem(name: "page_size", value: "10")
        ]
        
        let request = URLRequest(url: (urlComponents?.url)!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let games = try JSONDecoder().decode(GameResponse.self, from: data)
                completion(.success(games.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
                
    }
    
    func fetchDetailGame(id: Int, completion: @escaping(Result<GameDetail, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.rawg.io/api/games/\(id)")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: "1ab9d933688b43f6bae9b55c65ddb85c"),
        ]
        
        let request = URLRequest(url: (urlComponents?.url)!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let games = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(.success(games))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    
}
