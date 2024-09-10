//
//  LocationManager.swift
//  MinWeather
//
//  Created by Thiago Souza on 09/09/24.
//

import Foundation
import CoreLocation

protocol UserLocationProtocol {
    func onUserLocationPermissionGranted()
    func onUserLocationPermissionDenied()
    func onUserLocationReceived(latitude: Double, longitude: Double)
    func onUserLocationError()
}

class LocationManager {
    private let locationManager: CLLocationManager
    private let locationManagerDelegate: LocationManagerDelegate
    
    init(userLocationProtocol: UserLocationProtocol) {
        self.locationManager = CLLocationManager()
        self.locationManagerDelegate = LocationManagerDelegate(userLocationProtocol: userLocationProtocol)
        self.locationManager.delegate = self.locationManagerDelegate
        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }
    
    func requestPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    private(set) var userLocationProtocol: UserLocationProtocol
    
    init(userLocationProtocol: UserLocationProtocol) {
        self.userLocationProtocol = userLocationProtocol
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocationProtocol.onUserLocationReceived(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.userLocationProtocol.onUserLocationError()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .denied {
            self.userLocationProtocol.onUserLocationPermissionGranted()
        } else {
            self.userLocationProtocol.onUserLocationPermissionDenied()
        }
    }
}
