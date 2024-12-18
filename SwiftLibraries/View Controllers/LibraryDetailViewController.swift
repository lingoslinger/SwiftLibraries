//
//  LibraryDetailViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/25/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class LibraryDetailViewController: UIViewController {
    
    @IBOutlet weak var libraryPhoneTextView: UITextView!
    @IBOutlet weak var libraryAddressLabel: UILabel!
    @IBOutlet weak var libraryHoursLabel: UILabel!
    @IBOutlet weak var libraryMapView: MKMapView!
    
    var detailLibrary : Library?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detailLibrary?.branch ?? "Library name not available"
        let phone = detailLibrary?.phone ?? "Library phone unavailable"
        libraryPhoneTextView.text = "Phone: \(phone)"
        libraryAddressLabel.text = detailLibrary?.address ?? "Library address unavailable"
        libraryHoursLabel.text = detailLibrary?.serviceHours?.formattedHours ?? "Library hours unavailable"
        annotateMap()
    }
    
    
    func annotateMap() {
        let latitudeString = detailLibrary?.location?.latitude ?? ""
        let longitudeString = detailLibrary?.location?.longitude ?? ""
        let zoomLocation = CLLocationCoordinate2D.init(latitude: Double(latitudeString) ?? 0.0, longitude: Double(longitudeString) ?? 0.0)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = detailLibrary?.branch
        libraryMapView.addAnnotation(point)
        libraryMapView.setRegion(libraryMapView.regionThatFits(viewRegion), animated: true)
    }
}
