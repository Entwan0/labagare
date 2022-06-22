//
//  MapViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotation: CustomAnnotation?
    
    var idAnnotation = 0
    
    var locationManager: CLLocationManager!
    
    var images = [UIImage]()

        var pickedImage = false
        
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
        
        
        var annotations = [CustomAnnotation]()
        annotations.append(CustomAnnotation(title: "Jardin de ville",coordinate: CLLocationCoordinate2D(latitude: 45.192172782838604, longitude: 5.7265306562434475)))
        annotations.append(CustomAnnotation(title: "Université inter",coordinate: CLLocationCoordinate2D(latitude: 45.192149786088635, longitude: 5.723228886604267)))
        annotations.append(CustomAnnotation(title: "Piscine municipale",coordinate: CLLocationCoordinate2D(latitude: 45.19528110361686, longitude: 5.7667080713141035)))
        
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
            
            let addImageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            addImageButton.setImage(UIImage(named: "plus"), for: .normal)
            addImageButton.tag = annotation.hash
            
            addImageButton.addTarget(self, action: #selector(verificationAddIncident), for: .touchUpInside)
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = addImageButton
            
            let imageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageButton.setImage(UIImage(named: "image"), for: .normal)
            pinView.leftCalloutAccessoryView = imageButton
            imageButton.addTarget(self, action: #selector(afficheImage), for: .touchUpInside)
            

            return pinView
        } else {
            return nil
        }
    }
    
    @objc func afficheImage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "images") as ImagesViewController
        secondVC.images = self.images
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    @objc func verificationAddIncident(){
        //Creer dialogue alert
        let dialogMessage = UIAlertController(title: "confirmer", message: "Etes vous sûr de vouloir ajouter un incident ?", preferredStyle: .alert)
         
         // Créer boutton ok avec action ajout incident
         let ok = UIAlertAction(title: "Oui", style: .default, handler: { (action) -> Void in
             print("Ok boutton appuyé")
            self.updateIncident()
          })
        
        let okPhoto = UIAlertAction(title: "Oui avec photo", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            self.updateIncident()
         })
        
        // Boutton annuler
        let cancel = UIAlertAction(title: "Annuler", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
         
        //Ajoute les boutton au dialog alert
        dialogMessage.addAction(ok)
        dialogMessage.addAction(okPhoto)
        dialogMessage.addAction(cancel)
        
        // Presente le dialogue à l'utilisateur
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(image)
        }
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func updateIncident() {

        selectedAnnotation?.nbrIncident += 1
        
        mapView.annotations.forEach { (annotation) in
            if annotation is CustomAnnotation, (annotation as! CustomAnnotation).id == selectedAnnotation?.id {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let someDateTime = formatter.string(from: date)
                
                (annotation as! CustomAnnotation).listDate.append(someDateTime)
                (annotation as! CustomAnnotation).nbrIncident = selectedAnnotation?.nbrIncident ?? 0
                (annotation as! CustomAnnotation).subtitle = String(selectedAnnotation?.nbrIncident ?? 0) + " incidents depuis hier. Dernier à " + someDateTime
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
