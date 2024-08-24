//
//  LocationPermissionHandlerTests.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//

import XCTest
@testable import OpenWeatherApp

class LocationPermissionHandlerTests: XCTestCase {

    var permissionHandler: MockLocationPermissionHandler!

    override func setUp() {
        super.setUp()
        permissionHandler = MockLocationPermissionHandler()
    }

    func testRequestLocationPermissionGranted() {
        let expectation = XCTestExpectation(description: "Permission granted")

        permissionHandler.onPermissionGranted = {
            expectation.fulfill()
        }

        permissionHandler.triggerPermissionGranted() // Simulate permission being granted
        permissionHandler.requestLocationPermission()

        wait(for: [expectation], timeout: 2.0)
    }

    func testRequestLocationPermissionDenied() {
        let expectation = XCTestExpectation(description: "Permission denied")

        permissionHandler.onPermissionDenied = {
            expectation.fulfill()
        }

        permissionHandler.triggerPermissionDenied() // Simulate permission being denied
        permissionHandler.requestLocationPermission()

        wait(for: [expectation], timeout: 2.0)
    }
}
