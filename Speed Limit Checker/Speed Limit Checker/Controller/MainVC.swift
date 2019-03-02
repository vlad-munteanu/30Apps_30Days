//
//  MainVC.swift
//  Speed Limit Checker
//
//  Created by Vlad Munteanu on 3/2/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainVC: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var currentStreet: String = ""
    
    //main view
    let mainView = MainView()
    
    public override func loadView() {
        self.view = mainView
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
//                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
    }
    
    func setupMap() {
        mainView.mapView.showsUserLocation = true
        mainView.mapView.isScrollEnabled = false
        mainView.mapView.isRotateEnabled = false
        mainView.mapView.isPitchEnabled = false
        mainView.mapView.isZoomEnabled = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        latLong(lat: locations[0].coordinate.latitude, long: locations[0].coordinate.longitude)
        self.mainView.mapView.setRegion(region, animated: true)
        
        //This is in meters per second
        var speed: CLLocationSpeed = CLLocationSpeed()
        //This is in Miles per hour
        speed = locationManager.location!.speed * 2.236936284
        let newSpeed = Int(locationManager.location!.speed * 2.236936284)
        print(speed)
        mainView.speedLabel.text = "\(newSpeed) MPH"
    }
    
    
    
  
    func amISpeeding(currentSpeed speed:CLLocationSpeed) -> Int {
        return 0
    }
    
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.denied{
            locationManager.startUpdatingLocation()
        }
    }
    
    //Addy Func
    
    func latLong(lat: Double,long: Double) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                print("Country :- \(country)")
                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    print("City :- \(city)")
                    // State
                    if let state = placeMark.addressDictionary!["State"] as? String{
                        print("State :- \(state)")
                        // Street
                        if let street = placeMark.addressDictionary!["Street"] as? String{
                            print("Street :- \(street)")
                            let str = street
                            self.currentStreet = str
                            let streetNumber = str.components(
                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                            print("streetNumber :- \(streetNumber)" as Any)
                            
                            // ZIP
                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                print("ZIP :- \(zip)")
                                // Location name
                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                    print("Location Name :- \(locationName)")
                                    // Street address
                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                        print("Thoroughfare :- \(thoroughfare)")
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
}
