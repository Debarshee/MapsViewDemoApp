//
//  SearchTableViewCell.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 5/5/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell, AnnotationViewReusable {

    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    
    func configure(name: String, address: String) {
        placeNameLabel.text = name
        placeAddressLabel.text = address
    }
}
