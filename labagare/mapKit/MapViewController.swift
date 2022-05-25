//
//  MapViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotation: CustomAnnotation?
    
    var idAnnotation = 0
    
    var locationManager: CLLocationManager!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true

        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        // Nous centrons la carte sur la latitude et la longitude passée en paramètre
        //let center = CLLocationCoordinate2D(latitude: 45.19193413, longitude: 5.72666532)
        //centerMap(onLocation: center)
        
        
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
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region,animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    //MARK: -- Annotations --
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            button.setImage(UIImage(named: "plus"), for: .normal)
            button.tag = annotation.hash
            
            button.addTarget(self, action: #selector(updateIncident), for: .touchUpInside)
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = button

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
    
    @IBAction func ChangeMapTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = .satellite
        case 2 : mapView.mapType = .hybrid
        default: break
        }
    }

}
