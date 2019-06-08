//
//  ViewController.swift
//  Aegis
//
//  Copyright © 2019 Tanvi Khot. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    public var userID: String!
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var panicButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        let lastLatitude = UserDefaults.standard.double(forKey: "LastLatitude")
        let lastLongitude = UserDefaults.standard.double(forKey: "LastLongitude")
        let lastLocation = CLLocation(latitude: lastLatitude, longitude: lastLongitude)
        centerMapOnLocation(location: lastLocation)
        
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
        }else{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.navigationController?.present(loginViewController, animated: false, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        panicButton.layer.cornerRadius = panicButton.bounds.size.width/2
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mainMap.setRegion(coordinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mainMap.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.centerMapOnLocation(location: location)
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "LastLatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "LastLongitude")
        }
    }
}

