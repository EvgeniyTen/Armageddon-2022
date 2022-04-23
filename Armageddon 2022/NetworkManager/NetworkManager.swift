//
//  NetworkManager.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 21.04.2022.
//

import Foundation

let stringUrl = "https://api.nasa.gov/neo/rest/v1/feed?api_key=rFO5jo85RS8NKdQsUtwAdlOhBQXxgqmEo4b3bBcj"

class NetworkManager {
    
    
    func request(urlString: String, completion: @escaping
                 (Result<Asteroid, Error>) -> Void) {
        guard let url = URL(string: stringUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
            
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let asteroidsData = try JSONDecoder().decode(Asteroid.self, from: data)
                    completion(.success(asteroidsData))
                   
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))

                }

            }
        } .resume()
    }
    
}
