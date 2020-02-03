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
    var venues: [Venue] = []
    var checkLocation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocation = false
        guard let url = URL(string: "https://coinmap.org/api/v1/venues/") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let apiEvents = try JSONDecoder().decode(VenueList.self, from: data)
                //looping through decoded venues
                for apiEvent in apiEvents.venues {
                    self.venues.append(apiEvent)
                }
                self.addAnnoations()
            } catch {}
        }
        task.resume()
        configureLocationServices()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
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
        let region = MKCoordinateRegion(center: coordinate,latitudinalMeters: 500,longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    
    private func addAnnoations(){
        
        for venue in self.venues {
            let newAnnoation = MKPointAnnotation()
            newAnnoation.coordinate = CLLocationCoordinate2D(latitude: Double(venue.lat), longitude: Double(venue.lon))
            newAnnoation.title = venue.name
            mapView.addAnnotation(newAnnoation)
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        coordinate = latestLocation.coordinate
        if checkLocation == false {
            zoomToLocation(coordinate: coordinate)
            checkLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension ViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if annotation !== mapView.userLocation {
            annotationView?.image = UIImage(named: "bitcoinLogo40px")
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(view.annotation?.title)")
    }
}
