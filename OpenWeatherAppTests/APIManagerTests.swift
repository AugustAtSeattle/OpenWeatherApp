//
//  APIManagerTests.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//

import XCTest
@testable import OpenWeatherApp

class APIManagerTests: XCTestCase {

    var apiManager: APIManager!

    override func setUp() {
        super.setUp()
        apiManager = APIManager.shared
    }

    func testFetchCoordinatesForCityName() {
        let expectation = XCTestExpectation(description: "Fetch coordinates for city")

        apiManager.getCoordinates(for: "Seattle") { result in
            switch result {
            case .success(let coordinate):
                XCTAssertEqual(coordinate.latitude, 47.6062)
                XCTAssertEqual(coordinate.longitude, -122.3321)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchWeatherDataForCoordinates() {
        let expectation = XCTestExpectation(description: "Fetch weather data for coordinates")

        let coordinate = Coordinate(latitude: 47.6062, longitude: -122.3321)
        
        apiManager.fetchWeatherData(for: coordinate) { result in
            switch result {
            case .success(let weatherResponse):
                XCTAssertNotNil(weatherResponse)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
