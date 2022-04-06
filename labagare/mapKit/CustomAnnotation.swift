//
//  CustomAnnotation.swift
//  labagare
//
//  Created by volozana on 30/03/2022.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var id: String?
    var nbrIncident: Int = 0
    
    init(title:String,coordinate:CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}
