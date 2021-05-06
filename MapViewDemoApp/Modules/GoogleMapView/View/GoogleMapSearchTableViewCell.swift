//
//  GoogleMapSearchTableViewCell.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/26/21.
//

import UIKit

class GoogleMapSearchTableViewCell: UITableViewCell, AnnotationViewReusable {
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    
    func configure(configurator: GoogleMapSearchTableCellProtocol) {
        placeNameLabel.text = configurator.name
        placeAddressLabel.text = configurator.address
    }
}
