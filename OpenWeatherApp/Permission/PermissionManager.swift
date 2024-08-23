//
//  PermissionManager.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation
import CoreLocation

class PermissionManager {
    
    static let shared = PermissionManager()
    
    private init() {}
    
    func checkLocationPermission(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            completion(false)
        case .restricted, .denied:
            completion(false)
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    func requestLocationPermission(locationManager: CLLocationManager, completion: @escaping (Bool) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        default:
            completion(false)
        }
    }
}
