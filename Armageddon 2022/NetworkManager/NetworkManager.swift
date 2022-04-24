//
//  NetworkManager.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 21.04.2022.
//

import Foundation
import Alamofire

let stringUrl = "https://api.nasa.gov/neo/rest/v1/feed?api_key=rFO5jo85RS8NKdQsUtwAdlOhBQXxgqmEo4b3bBcj"

class NetworkManager {
    
    
    func asteriodRequest(urlString: String, completion: @escaping
                 (Result<Asteroid, Error>) -> Void) {
        guard let url = URL(string: stringUrl) else {return}
        
        AF.request(url).responseJSON { [weak self] response in
            guard self != nil else {return}
            if let error = response.error { print(error.localizedDescription)
                return
            }
            guard let data = response.data, let dataFromJson = try? JSONDecoder().decode(Asteroid.self, from: data) else { print("Decode error"); return}
            completion(.success(dataFromJson))
        }
    }
}
