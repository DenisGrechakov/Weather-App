//
//  LocationService.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import Foundation
import CoreLocation

// MARK: - Location Service Protocol

protocol LocationService {
    var currentLocation: CLLocationCoordinate2D? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestLocationPermission() async throws
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D
}

enum LocationError: Error {
    case denied
    case restricted
    case unknown
}

// MARK: - Location Service Implementation

final class LocationServiceImpl: NSObject, LocationService {
    static let shared = LocationServiceImpl()
    
    private let locationManager = CLLocationManager()
    
    private(set) var currentLocation: CLLocationCoordinate2D?
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Error>?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Permission
    
    func requestLocationPermission() async throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            try await withCheckedThrowingContinuation { continuation in
                self.authorizationContinuation = continuation
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            throw LocationError.denied
        case .restricted:
            throw LocationError.restricted
        case .authorizedWhenInUse, .authorizedAlways:
            return
        @unknown default:
            throw LocationError.unknown
        }
    }
    
    // MARK: - Request Location
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        let status = locationManager.authorizationStatus
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            try await requestLocationPermission()
            return try await requestCurrentLocation()
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.locationManager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationContinuation?.resume()
            authorizationContinuation = nil
        case .denied:
            authorizationContinuation?.resume(throwing: LocationError.denied)
            authorizationContinuation = nil
        case .restricted:
            authorizationContinuation?.resume(throwing: LocationError.restricted)
            authorizationContinuation = nil
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: LocationError.unknown)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
