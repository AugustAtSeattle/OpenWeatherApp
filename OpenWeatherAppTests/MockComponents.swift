//
//  MockComponents.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//
import Foundation
import CoreLocation
@testable import OpenWeatherApp

// MARK: - MockAPIManager

class MockAPIManager: APIManagerProtocol {

    var fetchWeatherDataResult: Result<WeatherResponse, NetworkError>?
    var fetchCoordinatesResult: Result<Coordinate, NetworkError>?

    func fetchWeatherData(for coordinate: Coordinate, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        if let result = fetchWeatherDataResult {
            completion(result)
        }
    }

    func getCoordinates(for cityName: String, completion: @escaping (Result<Coordinate, NetworkError>) -> Void) {
        if let result = fetchCoordinatesResult {
            completion(result)
        }
    }
}

// MARK: - MockLocationManager

class MockLocationManager: LocationManager {

    override init() {
        super.init()
    }

    var simulateLocation: CLLocation?
    var simulateError: Error?

    override func startUpdatingLocation() {
        if let location = simulateLocation {
            delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        if let error = simulateError {
            delegate?.didFailWithError(error)
        }
    }

    func simulateLocationUpdate(latitude: Double, longitude: Double) {
        delegate?.didUpdateLocation(latitude: latitude, longitude: longitude)
    }
    
    func simulateLocationError(error: Error) {
        delegate?.didFailWithError(error)
    }
}

// MARK: - MockPersistenceManager

class MockPersistenceManager: PersistenceManagerProtocol {

    private var storage: [String: Any] = [:]

    func save<T: Codable>(_ object: T, forKey key: String) {
        storage[key] = object
    }

    func retrieve<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        return storage[key] as? T
    }
    
    func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}

// MARK: - MockLocationPermissionHandler

class MockLocationPermissionHandler: LocationPermissionHandler {

    override init() {
        super.init()
    }

    var isPermissionGranted: Bool = false

    override func requestLocationPermission() {
        if isPermissionGranted {
            onPermissionGranted?()
        } else {
            onPermissionDenied?()
        }
    }

    func triggerPermissionGranted() {
        isPermissionGranted = true
        onPermissionGranted?()
    }

    func triggerPermissionDenied() {
        isPermissionGranted = false
        onPermissionDenied?()
    }
}

// MARK: - MockSearchViewModel

class MockSearchViewModel: SearchViewModel {

    init() {
        super.init()
    }

    var fetchWeatherCityName: String?
    var isLastSearchAvailableReturnValue: Bool = false

    override func fetchWeather(for cityName: String) {
        fetchWeatherCityName = cityName
    }

    override func isLastSearchAvailable() -> Bool {
        return isLastSearchAvailableReturnValue
    }
}
