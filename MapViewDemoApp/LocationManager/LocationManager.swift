//
//  OldLocationManager.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/23/21.
//

import CoreLocation
import Foundation
import GoogleMaps
import UIKit

class LocationManager: NSObject {
    
    private var locationManager: CLLocationManager
    var currentUserLocation: CLLocation?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.delegate = self
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        
        case .denied, .restricted:
            print("Location Access Required")
            
        @unknown default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let location = locations.first else { return }
        currentUserLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkAuthorizationStatus()
    }
}

extension LocationManager: LocationManagerProtocol {
    func fetchCurrentLocation() {
        self.locationManager.requestLocation()
        self.locationManager.stopUpdatingLocation()
    }
    
    func fetchContinuousLocation(for duration: TimeInterval) {
        self.locationManager.requestLocation()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.locationManager.stopUpdatingLocation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: workItem)
    }
    
    // MARK: Require CLPlacemark method
    func getAddressFromPlaceMark(_ placeMark: CLPlacemark) -> String {
        [placeMark.thoroughfare, placeMark.administrativeArea, placeMark.country, placeMark.postalCode ].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: ", ")
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) -> String {
        let geocoder = GMSGeocoder()
        var streetAddress = ""
        geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
            guard let address = response?.firstResult(),
                  let lines = address.lines else { return }
            streetAddress = lines.joined(separator: "\n")
        }
        return streetAddress
    }
    
    func geocode(addressString: String) -> CLLocation {
        let geoCoder = CLGeocoder()
        var coordinates = CLLocation(latitude: 0, longitude: 0)
        geoCoder.geocodeAddressString(addressString) { placemarks, _ in
            guard let location = placemarks?.first?.location else { return }
            coordinates = location
        }
        return coordinates
    }
}
