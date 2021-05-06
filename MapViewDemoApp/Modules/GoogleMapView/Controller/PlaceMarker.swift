//
//  PlaceMarker.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/26/21.
//

import GoogleMaps
import GooglePlaces
import UIKit

class PlaceMarker: GMSMarker {
    
      let place: GMSPlace
    
      init(place: GMSPlace, availableTypes: [String]) {
        self.place = place
        super.init()

        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop

        var foundType = "restaurant"
        let possibleTypes = !availableTypes.isEmpty ? availableTypes: ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
        guard let placeTypes = place.types else { return }
        for type in placeTypes {
          if possibleTypes.contains(type) {
            foundType = type
            break
          }
        }
        icon = UIImage(named: foundType + "_pin")
      }
}
