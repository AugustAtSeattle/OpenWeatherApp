//
//  GeocodeResponse.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

struct GeocodeResponse: Codable {
    let lat: Double
    let lon: Double
    let name: String
    let country: String
}
