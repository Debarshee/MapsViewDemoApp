//
//  MKMapView.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/24/21.
//

import MapKit

extension MKMapView {
    func centerTo(location: CLLocation, withRadius radius: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        setRegion(region, animated: true)
    }
}
