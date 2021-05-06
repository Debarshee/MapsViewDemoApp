//
//  GoogleMapViewController.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/25/21.
//

import GoogleMaps
import GooglePlaces
import UIKit

class GoogleMapViewController: UIViewController {

    @IBOutlet private weak var googleMapView: GMSMapView!
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet private weak var listTableView: UITableView! {
        didSet {
            self.listTableView.dataSource = self
            self.listTableView.delegate = self
        }
    }
    
    let locationManager = LocationManager()
    let router = Router<LocationApi>()
    lazy var mapViewModel = GoogleMapViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.fetchCurrentLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        googleMapView.delegate = self
        listTableView.isHidden = true
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(locationManager.reverseGeocode(coordinate: position.target))
    }
}

extension GoogleMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mapViewModel.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoogleMapSearchTableViewCell.viewIdentifier, for: indexPath) as? GoogleMapSearchTableViewCell else {
            fatalError("Failed to dequeue the cell")
        }
        guard let data = self.mapViewModel.searchData(at: indexPath.row) else {
            fatalError("failed to get data")
        }
        cell.configure(configurator: data)
        return cell
    }
}

extension GoogleMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.mapViewModel.searchData(at: indexPath.row) else { return }
        self.searchBar.text = data.name
    }
}

extension GoogleMapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listTableView.isHidden = false
        self.googleMapView.clear()
        self.mapViewModel.fetchNearbyPlaces(radius: 1000, keyword: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listTableView.isHidden = true
//        guard let data = self.localSearchDataSource else { return }
//        for location in data {
//            let selectedLatitude = CLLocationDegrees(location.geometry?.location?.lat ?? 0.0)
//            let selectedLongitude = CLLocationDegrees(location.geometry?.location?.lng ?? 0.0)
//            let currentCoordinate = CLLocationCoordinate2D(latitude: selectedLatitude, longitude: selectedLongitude)
//            mapViewModel.setPlacemark(mapView: self.googleMapView, coordinate: currentCoordinate)
//        }
    }
}

extension GoogleMapViewController: GoogleMapViewModelDelegate {
    func reloadData() {
        self.listTableView.reloadData()
    }
}
