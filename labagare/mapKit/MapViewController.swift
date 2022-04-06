//
//  MapViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotation: CustomAnnotation?
    
    var idAnnotation = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        // Nous centrons la carte sur la latitude et la longitude passée en paramètre
        let center = CLLocationCoordinate2D(latitude: 45.19193413, longitude: 5.72666532)
        centerMap(onLocation: center)
        
        
        var annotations = [CustomAnnotation]()
        annotations.append(CustomAnnotation(title: "Jardin de ville",coordinate: CLLocationCoordinate2D(latitude: 45.192172782838604, longitude: 5.7265306562434475)))
        annotations.append(CustomAnnotation(title: "test",coordinate: CLLocationCoordinate2D(latitude: 45.192149786088635, longitude: 5.723228886604267)))
        
        annotations.forEach{ (annotation) in
            annotation.id = String(self.idAnnotation)
            self.idAnnotation += 1
            
            annotation.nbrIncident = 0
            annotation.subtitle = "il y a 0 incidents depuis hier"
            mapView.addAnnotation(annotation)
        }
    }
    
    func centerMap(onLocation location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region,animated: true)
    }

    //MARK: -- Annotations --
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))

            let rightButton = UIButton(type: .infoLight)
            rightButton.tag = annotation.hash

            rightButton.addTarget(self, action: #selector(updateIncident), for: .touchUpInside)
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton

            return pinView
        } else {
            return nil
        }
    }

    
    @objc func updateIncident() {
        selectedAnnotation?.nbrIncident += 1
//        selectedAnnotation.subtitle = "il y a " + String(selectedAnnotation.nbrIncident)
        
        mapView.annotations.forEach { (annotation) in
            if annotation is CustomAnnotation, (annotation as! CustomAnnotation).id == selectedAnnotation?.id {
                (annotation as! CustomAnnotation).nbrIncident = selectedAnnotation?.nbrIncident ?? 0
                (annotation as! CustomAnnotation).subtitle = "il y a " + String(selectedAnnotation?.nbrIncident ?? 0) + " incidents depuis hier"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selected = view.annotation as? CustomAnnotation {
            self.selectedAnnotation = selected
        }
    }

    //MARK: -- Itinéraire --
    func directionsRequest(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }

        self.mapView.removeOverlays(mapView.overlays)
    }

    //show and custom the line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
}

class annotationTitleCoordonate {
    var title: String
    var coordonate: CLLocationCoordinate2D

    init (title: String, coordonate: CLLocationCoordinate2D) {
        self.title = title
        self.coordonate = coordonate
    }
}
