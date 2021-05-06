//
//  MapViewController.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/24/21.
//

import MapKit
import UIKit

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    @IBOutlet private weak var locationSearchBar: UISearchBar! {
        didSet {
            locationSearchBar.delegate = self
        }
    }
    @IBOutlet private weak var localSearchTable: UITableView! {
        didSet {
            self.localSearchTable.dataSource = self
            self.localSearchTable.delegate = self
        }
    }
    
    let mapViewModel = MapViewModel()
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.fetchCurrentLocation()
        mapViewModel.delegate = self
        localSearchTable.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerToLocation(location: mapView.userLocation)
    }
    
    // MARK: - Private Functions
    private func centerToLocation(location: MKUserLocation) {
        guard let location = location.location else { return }
        mapView.centerTo(location: location, withRadius: 3000)
    }
}

// MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerToLocation(location: userLocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let myAnnotation = annotation as? MyPoints else { return nil }
        let identifier = "Annotation View"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = myAnnotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: myAnnotation, reuseIdentifier: identifier)
            view.canShowCallout = false
        }
        view.glyphImage = UIImage(named: "SkyBlueLocationIcon")
        view.glyphTintColor = UIColor.red
        view.markerTintColor = UIColor.clear
        view.annotation = myAnnotation
        view.calloutOffset = CGPoint(x: -5, y: 5)
        let infoButton = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = infoButton
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        detailsViewController.location = view.annotation
        self.present(detailsViewController, animated: true, completion: nil)
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let myAnnotation = view.annotation else { return }
//        let calloutView = CalloutView(annotation: myAnnotation)
//        calloutView.translatesAutoresizingMaskIntoConstraints = false
//        calloutView.backgroundColor = UIColor.lightGray
//        view.addSubview(calloutView)
//
//        NSLayoutConstraint.activate([
//            calloutView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            calloutView.widthAnchor.constraint(equalToConstant: 100),
//            calloutView.heightAnchor.constraint(equalToConstant: 80),
//            calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x)
//        ])
//    }
}

// MARK: - Search bar Delegate
extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mapViewModel.search(query: searchBar.text ?? "", in: mapView.region)
        reloadData()
        localSearchTable.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapViewModel.search(query: searchBar.text ?? "", in: mapView.region)
        localSearchTable.isHidden = true
    }
}

// MARK: - MapViewModel Delegate
extension MapViewController: MapViewModelDelegate {
    func reloadData() {
        self.localSearchTable.reloadData()
    }
    
    func didFetchSearch() {
        mapView.addAnnotations(mapViewModel.annotationsForMap())
    }
    
    func clearAnnotations() {
        mapView.removeAnnotations(mapViewModel.annotationsForMap())
    }
    
    func didFail(with error: MapViewModel.MapError) {
        print(error)
    }
}

// MARK: - MapViewModel Delegate
extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mapViewModel.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.viewIdentifier, for: indexPath) as? SearchTableViewCell else {
            fatalError("Failed to dequeue the cell")
        }
        let data = mapViewModel.searchListShow(at: indexPath.row)
        // cell.configure(name: data.title, address: data.subtitle )
        cell.configure(name: data.title ?? "", address: data.subtitle ?? "" )
        return cell
    }
}

// MARK: - MapView Tableview Delegate
extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = mapViewModel.searchListShow(at: indexPath.row)
        self.locationSearchBar.text = data.title
        self.localSearchTable.isHidden = true
        // mapViewModel.selectedSearch(result: data)
    }
}

extension MapViewController: ExampleCalloutViewDelegate {
    func mapView(_ mapView: MKMapView, didTapDetailsButton button: UIButton, for annotation: MKAnnotation) {
        print("mapView(_:didTapDetailsButton:for:)")
    }
}
