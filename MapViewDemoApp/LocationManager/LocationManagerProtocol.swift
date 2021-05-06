//
//  LocationManagerProtocol.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 5/5/21.
//

import CoreLocation
import Foundation
import GoogleMaps
import UIKit

protocol LocationManagerProtocol {
    func fetchCurrentLocation()
    func fetchContinuousLocation(for duration: TimeInterval)
    func getAddressFromPlaceMark(_ placeMark: CLPlacemark) -> String
    func reverseGeocode(coordinate: CLLocationCoordinate2D) -> String
    func geocode(addressString: String) -> CLLocation
}
