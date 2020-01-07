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

final class UserData: ObservableObject {
    @Published var authorized = false
    @Published var passphrase = ""
    @Published var trains = trainData
    @Published var dataLoaded: Bool = false
    @Published var stations = [Station]()
    @Published var network: Bool = true
    let locationManager = CLLocationManager()
    
    init() {
        print("init")
        getStations()
        if self.authorized {
            beginHome()
        }
        
    }
    func beginHome() {
        print("running home fetches")
        if self.network {
            getNearestStation()
        }
    }
    func getNearestStation() {
        
        
        
    }
    func getStations (){
        
        Alamofire.request(baseAPI + "/api/v2/stations")
            .responseJSON{
                response in
                
                let responseJSON = JSON(response)
                print("spacer")
                print(response, "response status")
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
                    print(self.stations)
                } else {
                    print("error retreving stations")
                    self.network = false
                }
        }
        
    }
    
}
