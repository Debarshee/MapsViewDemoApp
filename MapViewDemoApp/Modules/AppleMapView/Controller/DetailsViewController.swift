//
//  DetailsViewController.swift
//  MapViewDemoApp
//
//  Created by Debarshee on 4/27/21.
//

import MapKit
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddress()
    }
    
    var location: MKAnnotation?
    
    private func setAddress() {
        placeNameLabel.text = location?.title ?? ""
        placeAddressLabel.text = location?.subtitle ?? ""
        phoneLabel.text = ""
    }
}
