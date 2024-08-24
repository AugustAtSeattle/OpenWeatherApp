//
//  PersistenceManagerTests.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//

import XCTest
@testable import OpenWeatherApp

class PersistenceManagerTests: XCTestCase {

    var persistenceManager: PersistenceManager!

    override func setUp() {
        super.setUp()
        persistenceManager = PersistenceManager.shared
    }

    func testSaveAndRetrieveLastSearchedCity() {
        let cityName = "Seattle"
        persistenceManager.save(cityName, forKey: "lastSearchedCity")
        
        let retrievedCityName = persistenceManager.retrieve(forKey: "lastSearchedCity", as: String.self)
        
        XCTAssertEqual(retrievedCityName, cityName)
    }

    func testRetrieveWhenNoLastSearchedCity() {
        let mockPersistenceManager = MockPersistenceManager()
        
        // No value has been saved for this key, so it should return nil
        let retrievedCityName: String? = mockPersistenceManager.retrieve(forKey: "lastSearchedCity", as: String.self)
        
        XCTAssertNil(retrievedCityName, "Expected to retrieve nil when no city name is saved, but got: \(String(describing: retrievedCityName))")
    }
}
