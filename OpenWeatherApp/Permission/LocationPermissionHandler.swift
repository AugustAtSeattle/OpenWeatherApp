//
//  LocationPermissionHandler.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation
import CoreLocation

class LocationPermissionHandler: NSObject, CLLocationManagerDelegate {
    var onPermissionGranted: (() -> Void)?
    var onPermissionDenied: (() -> Void)?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            onPermissionDenied?()
        case .authorizedWhenInUse, .authorizedAlways:
            onPermissionGranted?()
        @unknown default:
            onPermissionDenied?()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            onPermissionGranted?()
        case .denied, .restricted:
            onPermissionDenied?()
        default:
            break
        }
    }
}
