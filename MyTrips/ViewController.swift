//
//  ViewController.swift
//  MyTrips
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var trip: Dictionary<String,String> = [:]
    var selectedIndex: Int!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let index = selectedIndex {
            if index == -1 { //add
                setLocationManager()
            }else { //list
                showNote(trip: trip)
            }
        }
        
        //print(selectedIndex)
        
        let recognizeTouch = UILongPressGestureRecognizer(target: self, action: #selector( ViewController.pickMap(gesture:)) )
        recognizeTouch.minimumPressDuration = 2
        map.addGestureRecognizer( recognizeTouch )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Asking user for authorization to use GPS location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertController = UIAlertController(title: "Permission to GPS location", message: "GPS location is needed. Please, enable it!", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Open settings", style: .default, handler: { (alertController) in
                if let configs = NSURL( string: UIApplicationOpenSettingsURLString ) {
                    UIApplication.shared.open( configs as URL )
                }
            })
            
            let alertCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction( alertAction )
            alertController.addAction( alertCancel )
            
            present( alertController, animated: true, completion:  nil )
            
        }
    }
    
    func setLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //setting accuracy to best possible
        locationManager.requestWhenInUseAuthorization() //requesting user authorization
        locationManager.startUpdatingLocation() //updating user's location
    }
    
    //Retrieve user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Setting initial map exhibition
        let userLocation = locations.last!
        let latitude: CLLocationDegrees = userLocation.coordinate.latitude
        let longitude: CLLocationDegrees = userLocation.coordinate.longitude
        
        showPlace(latitude: latitude, longitude: longitude)
        
    }
    
    //Set gesture to pick place on map
    @objc func pickMap(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began {
            //retrieve coordinates
            let selectedPoint = gesture.location(in: self.map)
            let coordinates = map.convert( selectedPoint, toCoordinateFrom: self.map )
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            //var localName = ""
            //var localAddress = "Address not found!"
            var completeLocal = "Name/Address not found!"
            
            //retrieve address
            CLGeocoder().reverseGeocodeLocation( location, completionHandler: { ( local, erro ) in
                
                if erro == nil {
                    
                    if let localData = local?.first {
                        
                        if let name = localData.name {
                            completeLocal = name
                        } else{
                            if let address = localData.thoroughfare {
                                completeLocal = address
                            }
                        }
                    }
                    
                    //Save trips to device
                    self.trip = [ "place" : completeLocal , "latitude" : String(coordinates.latitude) , "longitude" : String(coordinates.longitude) ]
                    StoreData().saveTrip( trip: self.trip )
                    
                    //show notes with address data
                    self.showNote(trip: self.trip)
                    
                }else {
                    print( erro ?? "Failed while trying to retrieve location!" )
                }
                
            })
        }
    }
    
    //Show notes with address data
    func showNote(trip: Dictionary<String,String>){
        if let place = trip["place"]{
            if let latitude = trip["latitude"]{
                if let longitude = trip["longitude"]{
                    if let latitude = Double(latitude){
                        if let longitude = Double(longitude){
                            
                            //add note
                            addNote(latitude: Double(latitude),longitude: Double(longitude), place: place)
                            
                            //show place
                            showPlace(latitude: Double(latitude),longitude: Double(longitude))
                        }
                    }
                }
            }
        }
    }

    //Add note
    func addNote(latitude: Double, longitude: Double, place: String){
        let note = MKPointAnnotation()
        note.coordinate.latitude = latitude
        note.coordinate.longitude = longitude
        note.title = place
        
        self.map.addAnnotation( note )
    }
    
    //Show place
    func showPlace(latitude: Double, longitude: Double){
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
    }
    
}

