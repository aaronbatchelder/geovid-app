//
//  Place.swift
//  GeoVid
//
//  Created by Aaron Batchelder on 3/4/17.
//  Copyright © 2017 Aaron Batchelder. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {

    let title:String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
