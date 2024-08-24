//
//  SearchViewModelTests.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//
import XCTest
@testable import OpenWeatherApp

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var mockAPIManager: MockAPIManager!
    var mockLocationManager: MockLocationManager!
    var mockPersistenceManager: MockPersistenceManager!
    var mockLocationPermissionHandler: MockLocationPermissionHandler!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        mockLocationManager = MockLocationManager()
        mockPersistenceManager = MockPersistenceManager()
        mockLocationPermissionHandler = MockLocationPermissionHandler()
        
        viewModel = SearchViewModel(apiManager: mockAPIManager, locationManager: mockLocationManager, persistenceManager: mockPersistenceManager, locationPermissionHandler: mockLocationPermissionHandler)
    }

//    func testFetchWeatherByCityName() {
//        // Set up mock API response
//        let expectation = XCTestExpectation(description: "Fetch weather data")
//        
//        viewModel.onWeatherDataFetched = { weatherResponse, cityName in
//            XCTAssertEqual(cityName, "Seattle")
//            expectation.fulfill()
//        }
//        
//        viewModel.fetchWeather(for: "Seattle")
//        
//        wait(for: [expectation], timeout: 2.0)
//    }

//    func testFetchLocalWeatherWhenPermissionGranted() {
//        // Set up mock location and API responses
//        let expectation = XCTestExpectation(description: "Fetch local weather data")
//
//        viewModel.onWeatherDataFetched = { weatherResponse, cityName in
//            XCTAssertEqual(cityName, "Your Location")
//            expectation.fulfill()
//        }
//
//        viewModel.requestLocationPermission()
//        mockLocationPermissionHandler.triggerPermissionGranted()
//        mockLocationManager.simulateLocationUpdate(latitude: 47.6062, longitude: -122.3321)
//        
//        wait(for: [expectation], timeout: 2.0)
//    }

    func testHandlePermissionDenied() {
        let expectation = XCTestExpectation(description: "Handle permission denied")
        
        viewModel.onError = { error in
            XCTAssertEqual(error, "Location permission denied")
            expectation.fulfill()
        }
        
        viewModel.requestLocationPermission()
        mockLocationPermissionHandler.triggerPermissionDenied()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
