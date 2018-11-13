//
//  LibraryDetailViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/25/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class LibraryDetailViewController: UIViewController {
    
    @IBOutlet weak var libraryPhoneTextView: UITextView!
    @IBOutlet weak var libraryAddressLabel: UILabel!
    @IBOutlet weak var libraryHoursLabel: UILabel!
    @IBOutlet weak var libraryMapView: MKMapView!
    
    var detailLibrary : Library!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detailLibrary.libraryName
        libraryPhoneTextView.text = "Phone: \(detailLibrary.phone!)"
        libraryAddressLabel.text = detailLibrary.address
        libraryHoursLabel.text = detailLibrary.hoursOfOperation.formattedLibraryHours
        annotateMap()
    }
    
    
    func annotateMap() {
        let zoomLocation = CLLocationCoordinate2D.init(latitude: (detailLibrary.location.latitude as NSString).doubleValue,
                                                       longitude: (detailLibrary.location.longitude as NSString).doubleValue)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = detailLibrary.libraryName
        libraryMapView.addAnnotation(point)
        libraryMapView.setRegion(libraryMapView.regionThatFits(viewRegion), animated: true)
    }
}
