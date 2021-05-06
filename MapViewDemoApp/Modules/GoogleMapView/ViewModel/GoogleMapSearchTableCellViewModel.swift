//
//  GoogleMapSearchTableCellViewModel.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 5/5/21.
//

import Foundation

protocol GoogleMapSearchTableCellProtocol {
    var name: String { get }
    var address: String { get }
}

class GoogleMapSearchTableCellViewModel: GoogleMapSearchTableCellProtocol {
    
    private var datasource: PlaceInfo
    
    init(datasource: PlaceInfo) {
        self.datasource = datasource
    }
    
    var name: String {
        datasource.name ?? ""
    }
    
    var address: String {
        datasource.vicinity ?? ""
    }
}
