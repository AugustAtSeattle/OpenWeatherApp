//
//  NetworkError.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .networkError(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "The server responded with an invalid response."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "Failed to decode the data: \(error.localizedDescription)"
        }
    }
}
