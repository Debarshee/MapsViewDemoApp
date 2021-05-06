//
//  EndPointType.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/30/21.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/") else {
            fatalError("baseURL could not be configured.") }
        return url
    }
    var httpMethod: HTTPMethod {
        .get
    }
    var headers: HTTPHeaders? {
        nil
    }
}
