//
//  MyPoints.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 5/5/21.
//

import MapKit

class MyPoints: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var locationName: String?
    var image: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
