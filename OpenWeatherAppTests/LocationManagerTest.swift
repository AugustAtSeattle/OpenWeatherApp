//
//  LocationManagerTest.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//
import XCTest
import CoreLocation
@testable import OpenWeatherApp

// Mock delegate to capture delegate calls
class MockLocationManagerDelegate: LocationManagerDelegate {
    var onLocationUpdate: ((Double, Double) -> Void)?
    var onLocationError: ((Error) -> Void)?

    func didUpdateLocation(latitude: Double, longitude: Double) {
        onLocationUpdate?(latitude, longitude)
    }

    func didFailWithError(_ error: Error) {
        onLocationError?(error)
    }
}

class LocationManagerTests: XCTestCase {

    var locationManager: MockLocationManager!
    var delegate: MockLocationManagerDelegate!

    override func setUp() {
        super.setUp()
        locationManager = MockLocationManager()
        delegate = MockLocationManagerDelegate()
        locationManager.delegate = delegate
    }

    func testLocationUpdate() {
        let expectation = XCTestExpectation(description: "Location updated")

        delegate.onLocationUpdate = { latitude, longitude in
            XCTAssertEqual(latitude, 47.6062)
            XCTAssertEqual(longitude, -122.3321)
            expectation.fulfill()
        }
        
        locationManager.simulateLocationUpdate(latitude: 47.6062, longitude: -122.3321)
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testLocationError() {
        let expectation = XCTestExpectation(description: "Location error handled")

        delegate.onLocationError = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        locationManager.simulateLocationError(error: NSError(domain: "Test", code: 1, userInfo: nil))
        
        wait(for: [expectation], timeout: 2.0)
    }
}
