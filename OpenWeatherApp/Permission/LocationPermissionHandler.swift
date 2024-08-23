//
//  LocationPermissionHandler.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation
import CoreLocation

class LocationPermissionHandler: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var onPermissionGranted: (() -> Void)?
    var onPermissionDenied: (() -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        PermissionManager.shared.checkLocationPermission { [weak self] granted in
            if granted {
                self?.onPermissionGranted?()
            } else {
                self?.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    // CLLocationManagerDelegate
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
