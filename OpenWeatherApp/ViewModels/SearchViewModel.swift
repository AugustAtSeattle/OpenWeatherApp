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
    
    var onWeatherDataFetched: ((WeatherResponse, String) -> Void)?
    var onError: ((String) -> Void)?
    
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
            case .failure(let error):
                self?.onError?("Failed to get coordinates: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWeatherForLastSearchedCity() {
        if let lastCity = persistenceManager.retrieve(forKey: "lastSearchedCity", as: String.self) {
            fetchWeather(for: lastCity)
        } else {
            onError?("No previous search found")
        }
    }
    
    private func fetchLocalWeather() {
        locationManager.startUpdatingLocation()
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
