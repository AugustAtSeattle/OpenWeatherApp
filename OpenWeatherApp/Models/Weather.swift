//
//  Weather.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
