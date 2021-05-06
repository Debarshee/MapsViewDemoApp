//
//  GoogleMapViewModel.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/26/21.
//

import CoreLocation
import Foundation
import GoogleMaps
import GooglePlaces

protocol GoogleMapViewModelDelegate: AnyObject {
    func reloadData()
}

class GoogleMapViewModel {
    
    let router = Router<LocationApi>()
    let locationManager = LocationManager()
    weak var delegate: GoogleMapViewModelDelegate?
    
    var localSearchDataSource: [GoogleMapSearchTableCellViewModel]? {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
    init(delegate: GoogleMapViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Get current users location
    func getUserLocation() -> CLLocationCoordinate2D {
        guard let coordinate = self.locationManager.currentUserLocation?.coordinate else {
            fatalError("Cannot get user coordinate")
        }
        return coordinate
    }
    
    // MARK: - Get local search data
    func fetchNearbyPlaces(radius: Double, keyword: String) {
        router.request(.nearbyPlaces(keyword: keyword, coordinate: getUserLocation(), radius: radius)) { (result: Result<PlacesData, AppError>) in
            switch result {
            case .success(let data):
                guard let data = data.results else { return }
                self.localSearchDataSource = data.compactMap { GoogleMapSearchTableCellViewModel(datasource: $0) }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        self.localSearchDataSource?.count ?? 0
    }
    
    func searchData(at index: Int) -> GoogleMapSearchTableCellProtocol? {
        self.localSearchDataSource?[index]
    }
    
    func setPlacemark(mapView: GMSMapView, coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = "Hello World"
        marker.map = mapView
    }
}
