//
//  Coordinate.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinate: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    override init()      {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                print(location.coordinate)
            }
        }
    }
    
    
    
}

