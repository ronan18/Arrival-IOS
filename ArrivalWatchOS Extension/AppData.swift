//
//  AppData.swift
//  ArrivalWatchOS Extension
//
//  Created by Ronan Furuta on 4/10/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import CoreData
let defaults = UserDefaults.standard
let dateFormate = "hh:mm A"
let dateFormateDate = "hh:mm A MM/DD/YYYY"
private var apiUrl = "https://api.arrival.city"

class AppData: NSObject, ObservableObject,CLLocationManagerDelegate {
    @Published var text: String = defaults.string(forKey: "passphrase") ?? "none"
    @Published var lat: Double = 0
    @Published var long: Double = 0
    @Published var locationAcess: Bool = false
var locationManager = CLLocationManager()
    var container: NSPersistentContainer!
    var apiKey = "test"

    override init() {
        super.init()
        print("int")
        guard container != nil else {
                 fatalError("This view needs a persistent container.")
             }
         locationManager.requestWhenInUseAuthorization()
             if CLLocationManager.locationServicesEnabled() {
                 locationManager.delegate = self
                 locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                 locationManager.startUpdatingLocation()
                 print("loc enabled")
             }
        
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  print("recived location")
        if let location = locations.last {
        //    print(location.coordinate)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print(lat,long)
            //   getClosestStations()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
          // Location updates are not authorized.
          locationManager.stopUpdatingLocation()
          return
       }
        print(error)
       // Notify the user of any errors.
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("not determined")
              locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationAcess = true
                print("Status good")
                
            }
        case .restricted, .denied:
            self.locationAcess = false
            print("Status bad")
        }
        
    }
    
}
