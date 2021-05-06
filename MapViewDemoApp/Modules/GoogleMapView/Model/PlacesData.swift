//
//  PlacesData.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/28/21.
//

import Foundation

struct PlacesData: Decodable {
    var htmlAttributions: [String]?
    var nextPageToken: String?
    var results: [PlaceInfo]?
    
    enum CodingKeys: String, CodingKey {
        case results
        case htmlAttributions = "html_attributions"
        case nextPageToken = "next_page_token"
    }
}

struct PlaceInfo: Decodable {
    var businessStatus: String?
    var geometry: Geometry?
    var icon: String?
    var name: String?
    var openingHours: OpeningHours?
    var photos: [Photos]?
    var placeId: String?
    var plusCode: PlusCode?
    var rating: Double?
    var reference: String?
    var scope: String?
    var types: [String]?
    var userRatingsTotal: Int?
    var vicinity: String?
    
    enum CodingKeys: String, CodingKey {
        case geometry, icon, name, photos, rating, reference, scope, types, vicinity
        case businessStatus = "business_status"
        case openingHours = "opening_hours"
        case placeId = "place_id"
        case plusCode = "plus_code"
        case userRatingsTotal = "user_ratings_total"
    }
}

struct Geometry: Decodable {
    var location: LocationInfo?
    var viewport: Viewport?
}

struct OpeningHours: Decodable {
    var openNow: Bool
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Photos: Decodable {
    var height: Int?
    var htmlAttributions: [String]?
    var photoReference: String?
    var width: Int?
    
    enum CodingKeys: String, CodingKey {
        case height, width
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
    }
}

struct PlusCode: Decodable {
    var compoundCode: String?
    var globalCode: String?
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

struct LocationInfo: Decodable {
    var lat: Double?
    var lng: Double?
}

struct Viewport: Decodable {
    var northeast: NortheastLocation?
    var southwest: SouthwestLocation?
}

struct NortheastLocation: Decodable {
    var lat: Double?
    var lng: Double?
}

struct SouthwestLocation: Decodable {
    var lat: Double?
    var lng: Double?
}
