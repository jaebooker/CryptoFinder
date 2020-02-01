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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    let regionInMeters: Double = 10000.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        guard let newCoordinates = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: newCoordinates, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        coordinate = newCoordinates
        
        let annotation1 = MKPointAnnotation()
        annotation1.title = "Bulba Fett Tea"
        annotation1.subtitle = "Everyone's favourite tea inspired by everyone's favourite Star Trek character"
        annotation1.coordinate = coordinate
        mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.title = "Kale"
        annotation2.subtitle = "Kale French Fries!"
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 37.780664, longitude: -122.416183)
        mapView.addAnnotation(annotation2)
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
}

