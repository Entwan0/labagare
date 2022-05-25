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
    var listDate: Array<String>
    
    init(title:String,coordinate:CLLocationCoordinate2D) {
        self.listDate = []
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}
