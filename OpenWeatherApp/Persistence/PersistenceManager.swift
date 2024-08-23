//
//  PersistenceManager.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save object: \(error)")
        }
    }
    
    func retrieve<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            print("Failed to retrieve object: \(error)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
