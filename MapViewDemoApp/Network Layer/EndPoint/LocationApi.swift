//
//  LocationApi.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/30/21.
//

import CoreLocation
import Foundation

enum LocationApi {
    case nearbyPlaces(keyword: String, coordinate: CLLocationCoordinate2D, radius: Double)
}

extension LocationApi: EndPointType {
    var path: String {
        switch self {
        case .nearbyPlaces:
            return "place/nearbysearch/json"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .nearbyPlaces(keyword, coordinate, radius):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: [
                                        "location": "\(coordinate.latitude),\(coordinate.longitude)",
                                        "radius": radius,
                                        "keyword": keyword,
                                        "key": "AIzaSyDQ6DJQRELu0RM66JkB-ef86Yy66RfFCmE"
                                      ]
            )
        }
    }
}
