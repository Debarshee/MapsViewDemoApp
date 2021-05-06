//
//  MapViewModel.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/28/21.
//

import MapKit

protocol MapViewModelDelegate: AnyObject {
    func didFetchSearch()
    func clearAnnotations()
    func didFail(with error: MapViewModel.MapError)
    func reloadData()
}

class MapViewModel: NSObject {
    
    enum MapError: Error {
        case emptySearchField
        case localSearchFailed
        case emptyResult
        
        static func parseError(error: Error?) -> Self {
            .localSearchFailed
        }
    }
    // MARK: MKLocalSearchCompleter
    // var searchCompleter = MKLocalSearchCompleter()
    let locationManager = LocationManager()
//    private var searchResults = [MKLocalSearchCompletion]() {
//        didSet {
//            self.delegate?.reloadData()
//        }
//    }
    
    private var searchResults = [MyPoints]() {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
    weak var delegate: MapViewModelDelegate?
    
    private var results = [MyPoints]() {
        didSet {
            self.delegate?.didFetchSearch()
            self.delegate?.reloadData()
        }
    }
    
    func annotationsForMap() -> [MyPoints] {
        results
    }
    
    // MARK: Search query entered in search bar
    func search(query: String, in region: MKCoordinateRegion) {
        // searchCompleter.delegate = self
        let searchQuery = query.trimmingCharacters(in: .whitespaces)
        guard !searchQuery.isEmpty else {
            self.delegate?.didFail(with: .emptySearchField)
            return
        }
        performSearch(with: query, in: region)
        // performSearchCompleter(with: query, in: region)
    }
    
    // MARK: Perform search within a region using MKLocalSearchCompleter
//    private func performSearchCompleter(with query: String, in region: MKCoordinateRegion) {
//        searchCompleter.queryFragment = query
//        searchCompleter.region = region
//    }
    
//    func selectedSearch(result: MKLocalSearchCompletion) {
//        let request = MKLocalSearch.Request(completion: result)
//        request.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.restaurant])
//        let search = MKLocalSearch(request: request)
//        search.start { [weak self] response, error in
//            guard error == nil, let results = response else {
//                self?.delegate?.didFail(with: MapError.parseError(error: error))
//                return
//            }
//            guard !results.mapItems.isEmpty else {
//                self?.delegate?.didFail(with: .emptyResult)
//                return
//            }
//
//            let annotations = results.mapItems.map { mapItem -> MyPoints in
//                let annotation = MyPoints(coordinate: mapItem.placemark.coordinate)
//                annotation.title = mapItem.name
//                annotation.subtitle = self?.locationManager.getAddressFromPlaceMark(mapItem.placemark)
//                return annotation
//            }
//            self?.delegate?.clearAnnotations()
//            self?.results = annotations
//        }
//    }
    
    // MARK: Perform search within a region using MKLocalSearch
    private func performSearch(with query: String, in region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        request.resultTypes = [.pointOfInterest]
        request.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.restaurant])
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard error == nil, let results = response else {
                self?.delegate?.didFail(with: MapError.parseError(error: error))
                return
            }
            guard !results.mapItems.isEmpty else {
                self?.delegate?.didFail(with: .emptyResult)
                return
            }
            
            let annotations = results.mapItems.map { mapItem -> MyPoints in
                let annotation = MyPoints(coordinate: mapItem.placemark.coordinate)
                annotation.title = mapItem.name
                annotation.subtitle = self?.locationManager.getAddressFromPlaceMark(mapItem.placemark)
                return annotation
            }
            self?.delegate?.clearAnnotations()
            self?.results = annotations
        }
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        self.results.count
    }
    
//    func searchListShow(at index: Int) -> MKLocalSearchCompletion {
//        self.searchResults[index]
//    }
    
    func searchListShow(at index: Int) -> MyPoints {
        self.results[index]
    }
}

// extension MapViewModel: MKLocalSearchCompleterDelegate {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        self.searchResults = completer.results
//    }
// }
