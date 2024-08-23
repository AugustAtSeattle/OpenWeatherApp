//
//  Endpoint.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    static func weatherByCityName(_ cityName: String, apiKey: String) -> Endpoint {
        return Endpoint(path: "/data/2.5/weather",
                        queryItems: [
                            URLQueryItem(name: "q", value: cityName),
                            URLQueryItem(name: "appid", value: apiKey)
                        ])
    }
    
    static func weatherByCoordinates(lat: Double, lon: Double, apiKey: String) -> Endpoint {
        return Endpoint(path: "/data/2.5/weather",
                        queryItems: [
                            URLQueryItem(name: "lat", value: "\(lat)"),
                            URLQueryItem(name: "lon", value: "\(lon)"),
                            URLQueryItem(name: "appid", value: apiKey)
                        ])
    }
}
