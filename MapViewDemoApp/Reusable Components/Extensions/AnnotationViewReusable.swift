//
//  AnnotationViewReusable.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/25/21.
//

import MapKit

protocol AnnotationViewReusable {
    static var viewIdentifier: String { get }
}

extension AnnotationViewReusable {
    static var viewIdentifier: String {
        String(describing: self)
    }
}
