//
//  MapViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController,LocationHandlerProtocol {
   
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var dismissButton: MapViewSpeedButton!
    var locationSpeed = CLLocationSpeed()
    let locationHandler = LocationHandler()
    
      //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHandler.startLocationTracking()
        mapView.showsUserLocation = true
      
        if UserDefaults.standard.value(forKey: "type") != nil {
            let value = UserDefaults.standard.value(forKey: "type")  as?  String
            if value == "cyclist"{
                setupNavBarWithUser(Type:"cyclist")
            }else{
                setupNavBarWithUser(Type:"jogger")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationHandler.locationHandlerProtocol = self
        
    }
    
     //MARK:- Location methods
    func locationHandlerDidUpdateLocationWithSpeed(speed: Double, location: CLLocation) {
        mapView.setCenter(location.coordinate, animated: true)
        dismissButton.setCurrentSpeed(speed: speed)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0.02, longitudinalMeters: 0.02)
        mapView.setRegion(region, animated: true)
    }
    
     //MARK:- Button actions
    @IBAction func CloseBtn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissView() {
    }

}
