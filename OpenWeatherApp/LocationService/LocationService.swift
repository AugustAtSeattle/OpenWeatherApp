//
//  LocationService.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation

class LocationService: LocationManagerDelegate {
    
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocationPermission()
        locationManager.startUpdatingLocation()
    }
    
    // LocationManagerDelegate methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        // Handle the updated location coordinates, e.g., fetch weather data
        print("Location updated: (\(latitude), \(longitude))")
    }
    
    func didFailWithError(error: Error) {
        // Handle location update failure
        print("Failed to update location: \(error.localizedDescription)")
    }
}
