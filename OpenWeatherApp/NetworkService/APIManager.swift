//
//  APIManager.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func fetchWeatherData(for endpoint: Endpoint, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
