//
//  SearchViewModel.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//
import Foundation
import CoreLocation

class SearchViewModel: LocationManagerDelegate {
    
    private let apiManager: APIManager
    private let locationManager: LocationManager
    private let persistenceManager: PersistenceManager
    private let locationPermissionHandler: LocationPermissionHandler
    
    // Closure to notify the ViewController when the last search availability changes
    var onLastSearchUpdated: ((Bool) -> Void)?
    var onWeatherDataFetched: ((WeatherResponse, String) -> Void)?
    var onError: ((String) -> Void)?
    var onLocationPermissionGranted: (() -> Void)?
    
    
    init(apiManager: APIManager = APIManager.shared,
         locationManager: LocationManager = LocationManager(),
         persistenceManager: PersistenceManager = PersistenceManager.shared,
         locationPermissionHandler: LocationPermissionHandler = LocationPermissionHandler()) {
        self.apiManager = apiManager
        self.locationManager = locationManager
        self.persistenceManager = persistenceManager
        self.locationPermissionHandler = locationPermissionHandler
        
        setupHandlers()
    }
    
    private func setupHandlers() {
        locationPermissionHandler.onPermissionGranted = { [weak self] in
            self?.onLocationPermissionGranted?()
            self?.fetchLocalWeather()
        }
        locationPermissionHandler.onPermissionDenied = { [weak self] in
            self?.onError?("Location permission denied")
        }
        
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationPermissionHandler.requestLocationPermission()
    }
    
    func fetchWeather(for cityName: String) {
        apiManager.getCoordinates(for: cityName) { [weak self] result in
            switch result {
            case .success(let coordinate):
                self?.fetchWeatherData(for: coordinate, cityName: cityName)
                self?.persistenceManager.save(cityName, forKey: "lastSearchedCity")
                
                self?.onLastSearchUpdated?(true)
                
            case .failure(let error):
                self?.onError?("Failed to get coordinates: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchLocalWeather() {
        locationManager.startUpdatingLocation()  // Start the location manager to fetch current location
    }
    
    func fetchWeatherForLastSearchedCity() {
        if let lastCity = persistenceManager.retrieve(forKey: "lastSearchedCity", as: String.self) {
            fetchWeather(for: lastCity)
        } else {
            onError?("No previous search found")
        }
    }
    
    func isLastSearchAvailable() -> Bool {
        return persistenceManager.retrieve(forKey: "lastSearchedCity", as: String.self) != nil
    }
        
    func fetchWeatherData(for coordinate: Coordinate, cityName: String) {
        apiManager.fetchWeatherData(for: coordinate) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                self?.onWeatherDataFetched?(weatherResponse, cityName)
            case .failure(let error):
                self?.onError?("Failed to get weather data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - LocationManagerDelegate Methods
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        fetchWeatherData(for: coordinate, cityName: "Your Location")
    }
    
    func didFailWithError(_ error: Error) {
        onError?("Failed to get your location: \(error.localizedDescription)")
    }
}
