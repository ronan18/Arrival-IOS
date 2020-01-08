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
import CoreData
var container: NSPersistentContainer!
//let baseURL = "http://localhost:3000"
let baseURL = "https://api.arrival.city"

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
final class UserData: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var authorized = false
    @Published var ready = false
    //@Published var passphrase = ""
    @Published var passphrase = ""
    @Published var trains: Array = [Train]()
    @Published var dataLoaded: Bool = false
    @Published var stations = [Station]()
    @Published var closestStation = Station(id: 0, name: "test", lat: 0.0, long: 0.0, abbr: "test")
    @Published var network: Bool = true
    @Published var lat: Double = 0.0
    @Published var long: Double = 0.0
    @Published var lastLat: Double = 0.0
    @Published var lastLong: Double = 0.0
    @Published var startedTrains: Bool = false
    let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        print("init")
        login()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("location auth")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print("no location auth")
        }
        
        
        
        
    }
    func login() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print(result, "user")
            if (result.isEmpty) {
                self.ready = true
                
            } else {
              let nsResult =  result as! [NSObject]
                self.passphrase = nsResult[0].value(forKey: "passphrase") as! String
                print(self.passphrase)
                let headers: HTTPHeaders = [
                                  "Authorization": self.passphrase,
                                  "Accept": "application/json"
                              ]
                Alamofire.request("https://api.arrival.city/api/v2/login", headers: headers).responseJSON {
                             response in //print(response.value)
                             let jsonResponse = JSON(response.value)
                             if jsonResponse["user"].stringValue == "true" {
                                 self.authorized = true
                                    self.ready = true
                                self.getStations()
                                
                                 print("user authorized")
                            
                                 
                             } else {
                                 print("user not authorized")
                                self.authorized = false
                                self.passphrase = ""
                                self.ready = true
                             }
                         }
 
            }
        } catch {
            
            print("Failed")
        }
    }
    func runTrains() {
        print("running Trains")
        self.startedTrains = true
        self.fetchTrains()
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.fetchTrains()
        }
        
    }
    func fetchTrains() {
       
        if (self.authorized) {
             print("fetching trains from", self.closestStation.abbr)
            let headers: HTTPHeaders = [
                "Authorization": self.passphrase,
                "Accept": "application/json"
            ]
            Alamofire.request(baseURL + "/api/v2/trains/" + self.closestStation.abbr, headers: headers).responseJSON { response in
                print(JSON(response.value))
                let estimates = JSON(JSON(response.value)["estimates"]["etd"].arrayValue)
                print(estimates.count)
                var results: Array = [Train]()
                for i in 0...estimates.count - 1 {
                    for x in 0...estimates[i]["estimate"].arrayValue.count - 1 {
                        let thisTrain = estimates[i]["estimate"][x]
                        results.append(Train(id: UUID(), direction: estimates[i]["destination"].stringValue, time: thisTrain["minutes"].intValue, unit: "min", color: thisTrain["color"].stringValue))
                    }
                }
                results.sort {
                    $0.time < $1.time
                }
                self.trains = results
                
                
            }
        } else {
            print("attempted train fetch but no auth")
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return  print("errorlocation?")
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.long = locValue.longitude
        getNearestStation()
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
        let locationChange = self.lat != self.lastLat || self.long != self.lastLong
        if (self.lat != 0 && self.stations.count > 0 && locationChange ) {
            print("have location")
            let myCord: CLLocation = CLLocation(latitude: self.lat, longitude: self.long)
            print(self.lat, self.long)
            var closestStation = Station(id: 0, name: "test", lat: 0.0, long: 0.0, abbr: "test")
            var closestdistance:Double = 0.0
            for i in 0...self.stations.count - 1 {
                
                let station = self.stations[i]
                //  print(self.stations)
                print(station.lat, station.long)
                let stationLoc: CLLocation = CLLocation(latitude: station.lat, longitude: station.long)
                //  let distanceMiles = distance(lat1: station.lat, lon1: station.long, lat2: self.lat,lon2: self.long, unit: "K")
                let distanceMiles = myCord.distance(from: stationLoc)
                
                
                print(station.name,distanceMiles)
                if (closestdistance == 0 || closestdistance > distanceMiles) {
                    closestStation = station
                    closestdistance = distanceMiles
                }
                
            }
            print(closestStation, closestdistance)
            var newStation: Bool = false
            if (closestStation.abbr != self.closestStation.abbr) {
                newStation = true
            }
            self.closestStation = closestStation
            self.lastLong = self.long
            self.lastLat = self.lat
            if (!self.startedTrains) {
                runTrains()
            } else {
                if newStation {
                    fetchTrains()
                }
            }
            
        } else {
            print("no location")
        }
        
        
        
        
    }
    
    func getStations (){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StationCore")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var stations: [Station] = []
            var version: Int = 0
            for data in result as! [NSObject] {
                let name = data.value(forKey: "name") as! String
                let abbr = data.value(forKey: "abbr") as! String
                let id = data.value(forKey: "id") as! Int
                let lat = data.value(forKey: "lat") as! Double
                let long = data.value(forKey: "long") as! Double
                stations.append(Station(id: id,name: name,lat: lat,long: long,abbr: abbr))
                version = data.value(forKey: "version") as! Int
            }
            print(stations.count, version)
            if (stations.count == 0) {
                Alamofire.request(baseAPI + "/api/v3/stations")
                    .responseJSON{
                        response in
                        
                        //  print("spacer")
                        //  print(response, "response status")
                        if  response.value != nil {
                            let stationJSON = JSON(response.value)
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationCore")
                            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                            
                            for i in 0..<stationJSON["stations"].arrayValue.count {
                                let json = stationJSON["stations"][i]
                                let id = json["_id"].intValue
                                let name = json["name"].stringValue
                                let abbr = json["abbr"].stringValue
                                let lat = json["gtfs_latitude"].doubleValue
                                let long = json["gtfs_longitude"].doubleValue
                                let entity = NSEntityDescription.entity(forEntityName: "StationCore", in: context)
                                let newStation = NSManagedObject(entity: entity!, insertInto: context)
                                newStation.setValue(name, forKey: "name")
                                newStation.setValue(id, forKey: "id")
                                newStation.setValue(abbr, forKey: "abbr")
                                newStation.setValue(lat, forKey: "lat")
                                newStation.setValue(long, forKey: "long")
                                newStation.setValue(stationJSON["version"].intValue, forKey: "version")
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                                self.stations.append(Station(id:id, name: name, lat: lat, long: long, abbr: abbr))
                            }
                            //   print(self.stations)
                            
                            print("got stations from server")
                            if self.authorized {
                                self.beginHome()
                            }
                        } else {
                            print("error retreving stations")
                            self.network = false
                        }
                }
            } else {
                self.stations = stations
                print("got stations from core data")
                if self.authorized {
                    self.beginHome()
                }
            }
            
        } catch {
            
            print("Failed")
        }
        
        
        
    }
    
}
