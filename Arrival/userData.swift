//
//  userData.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
import Alamofire
import SwiftyJSON
import CoreLocation
//let baseURL = "http://localhost:3000"
let baseURL = "https://api.arrival.city"


final class UserData: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var authorized = true
    //@Published var passphrase = ""
    @Published var passphrase = "test"
    @Published var trains = trainData
    @Published var dataLoaded: Bool = false
    @Published var stations = [Station]()
    @Published var network: Bool = true
    @Published var lat: Double = 0.0
    @Published var long: Double = 0.0
    let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        print("init")
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("location auth")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("no location auth")
        }
        
        getStations()
        if self.authorized {
            beginHome()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return  print("errorlocation?")
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lat = locValue.longitude
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            print("no location access")
        }
    }
    func beginHome() {
        print("running home fetches")
        if self.network {
            getNearestStation()
        }
    }
    func getNearestStation() {
        print("getting nearest station")
        
        
        
        
    }
    
    func getStations (){
        
        Alamofire.request(baseAPI + "/api/v2/stations")
            .responseJSON{
                response in
                
                //  print("spacer")
                //  print(response, "response status")
                if  response.value != nil {
                    let stationJSON = JSON(response.value)
                    for i in 0..<stationJSON.count {
                        let json = stationJSON[i]
                        let id = json["_id"].intValue
                        let name = json["name"].stringValue
                        let abbr = json["abbr"].stringValue
                        let lat = json["gtfs_latitude"].doubleValue
                        let long = json["gtfs_longitude"].doubleValue
                        self.stations.append(Station(id:id, name: name, lat: lat, long: long, abbr: abbr))
                    }
                    //  print(self.stations)
                    print("got stations")
                } else {
                    print("error retreving stations")
                    self.network = false
                }
        }
        
    }
    
}
