//
//  APIManager.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import UIKit
import Foundation

protocol APIManagerProtocol {
    func fetchWeatherData(for coordinate: Coordinate, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
    func getCoordinates(for cityName: String, completion: @escaping (Result<Coordinate, NetworkError>) -> Void)
}

class APIManager: APIManagerProtocol {
    
    private init() {}

    static let shared = APIManager()
        
    private let apiKey = ""

    // Step 1: Obtain geographic coordinates using the Geocoding API
    func getCoordinates(for cityName: String, completion: @escaping (Result<Coordinate, NetworkError>) -> Void) {
        let endpoint = Endpoint.geocode(cityName: cityName, apiKey: apiKey)
        
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let geocodeResponse = try JSONDecoder().decode([GeocodeResponse].self, from: data)
                if let firstLocation = geocodeResponse.first {
                    let coordinate = Coordinate(latitude: firstLocation.lat, longitude: firstLocation.lon)
                    completion(.success(coordinate))
                } else {
                    completion(.failure(.noData))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    
    // Step 2: Use the coordinates to request weather data
    func fetchWeatherData(for coordinate: Coordinate, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let endpoint = Endpoint.weatherByCoordinates(lat: coordinate.latitude, lon: coordinate.longitude, apiKey: apiKey)
        
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
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



// The utility function for downloading images
extension URLSession {
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = self.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
