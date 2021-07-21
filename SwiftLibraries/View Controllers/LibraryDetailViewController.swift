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
        title = detailLibrary?.name ?? "Library name not available"
        let phone = detailLibrary?.phone ?? "Library phone unavailable"
        
        var numberOfMatches = 0
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            numberOfMatches = detector.numberOfMatches(in: phone, range: NSRange(phone.startIndex..., in: phone))
        } catch {
            print(error) // TODO: error handling
        }
        
        if numberOfMatches == 0 {
            libraryPhoneTextView.textColor = UIColor.red
            libraryPhoneTextView.text = phone // so far, "Closed for Construction" is the only message we have seen here other than an actual phone number
        } else {
            libraryPhoneTextView.text = "Phone: \(phone)"
        }
        libraryAddressLabel.text = detailLibrary?.address ?? ""
        libraryHoursLabel.text = detailLibrary?.hoursOfOperation?.formattedHours ?? ""
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
        point.title = detailLibrary?.name
        libraryMapView.addAnnotation(point)
        libraryMapView.setRegion(libraryMapView.regionThatFits(viewRegion), animated: true)
    }
}
