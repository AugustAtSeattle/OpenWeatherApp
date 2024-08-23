//
//  UserPreferences.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

struct UserPreferences {
    
    private enum Keys {
        static let lastSearchedCity = "lastSearchedCity"
    }
    
    static var lastSearchedCity: String? {
        get {
            return PersistenceManager.shared.retrieve(forKey: Keys.lastSearchedCity, as: String.self)
        }
        set {
            if let city = newValue {
                PersistenceManager.shared.save(city, forKey: Keys.lastSearchedCity)
            } else {
                PersistenceManager.shared.remove(forKey: Keys.lastSearchedCity)
            }
        }
    }
}
