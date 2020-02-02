//
//  ViewController.swift
//  CryptoFinder
//
//  Created by Jaeson Booker on 2/1/20.
//  Copyright © 2020 Jaeson Booker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    var checkLocation: Bool = false
    //let regionInMeters: Double = 10000.0

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocation = false
        configureLocationServices()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        guard let newCoordinates = locationManager.location?.coordinate else { return }
//        let region = MKCoordinateRegion(center: newCoordinates, latitudinalMeters: 500, longitudinalMeters: 500)
//        mapView.setRegion(region, animated: true)
//        coordinate = newCoordinates
//
//        let annotation1 = MKPointAnnotation()
//        annotation1.title = "Bulba Fett Tea"
//        annotation1.subtitle = "Everyone's favourite tea inspired by everyone's favourite Star Trek character"
//        annotation1.coordinate = coordinate
//        mapView.addAnnotation(annotation1)
//
//        let annotation2 = MKPointAnnotation()
//        annotation2.title = "Kale"
//        annotation2.subtitle = "Kale French Fries!"
//        annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.780664, longitude: -122.416183)
//        mapView.addAnnotation(annotation2)
        
    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        pin.canShowCallout = true
//        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        return pin
//    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func zoomToLocation(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate,latitudinalMeters: 9000,longitudinalMeters: 15000)
        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnoations(){
        
        let testAnnotation = MKPointAnnotation()
        testAnnotation.title = "Bulba Fett Tea"
        testAnnotation.subtitle = "Everyone's favourite tea inspired by everyone's favourite Star Trek character"
        testAnnotation.coordinate = coordinate
        
        let testAnnotation2 = MKPointAnnotation()
        testAnnotation2.title = "Kale"
        testAnnotation2.subtitle = "Kale French Fries!"
        testAnnotation2.coordinate = CLLocationCoordinate2D(latitude: 37.780664, longitude: -122.416183)
        
        mapView.addAnnotation(testAnnotation)
        mapView.addAnnotation(testAnnotation2)
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        coordinate = latestLocation.coordinate
        if checkLocation == false {
            zoomToLocation(coordinate: coordinate)
            addAnnoations()
            checkLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

