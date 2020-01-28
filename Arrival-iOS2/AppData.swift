//
//  AppData.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/15/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import SwiftyJSON
import Alamofire
import CoreLocation


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let baseURL = "https://api.arrival.city"

class AppData: NSObject, ObservableObject,CLLocationManagerDelegate {
    
    @Published var trains: Array = [Train]()
    @Published var passphrase: String = ""
    @Published var ready: Bool = false
    @Published var auth: Bool = false
    @Published var stations = [Station]()
    @Published var network = true
    @Published var goingOffClosestStation: Bool = true
    @Published var closestStations = [Station]()
    @Published var toStationSuggestions = [Station]()
    @Published var fromStation: Station = Station(id: "loading", name: "loading", lat: 0.0, long: 0.0, abbr: "load", version: 0)
    @Published var toStation: Station = Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0)
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLat = 0.0
    private var lastLong = 0.0
    private var allowCycle = true
    override init() {
        super.init()
        print("init function")
        start()
        getStations()
    }
    func convertColor(color: String) -> Color {
        switch (color) {
        case "RED" :
            return Color.red
        case "YELLOW" :
            return Color.yellow
        case "GREEN" :
            return Color.green
        case "ORANGE" :
            return Color.orange
        case "PURPLE" :
            return Color.purple
        case "BLUE" :
            return Color.blue
        case "none" :
            return Color.white
        default :
            return Color.black
            
        }
    }
    func setFromStation(station: Station) {
        print("setting from Station")
        self.fromStation = station
        self.goingOffClosestStation = false
        self.cylce()
    }
    func setToStation(station: Station) {
        print("setting from Station")
        self.toStation = station
        
        self.cylce()
    }
    @objc func cylce() {
        if (self.fromStation.name != "loading" && self.auth && self.ready && !self.passphrase.isEmpty && allowCycle) {
            print("cycling", self.passphrase)
            if (self.toStation.id == "none" ) {
                print("fetching trains from", self.fromStation.abbr)
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                Alamofire.request(baseURL + "/api/v2/trains/" + self.fromStation.abbr, headers: headers).responseJSON { response in
                    // print(JSON(response.value))
                    let estimates = JSON(JSON(response.value)["estimates"]["etd"].arrayValue)
                    //   print(estimates.count)
                    var results: Array = [Train]()
                    for i in 0...estimates.count - 1 {
                        for x in 0...estimates[i]["estimate"].arrayValue.count - 1 {
                            let thisTrain = estimates[i]["estimate"][x]
                            let color = thisTrain["color"].stringValue
                            
                            results.append(Train(id: UUID(), direction: estimates[i]["destination"].stringValue, time: thisTrain["minutes"].stringValue, unit: "min", color: color, cars: thisTrain["length"].intValue, hex: thisTrain["hexcode"].stringValue, eta: ""))
                        }
                    }
                    results.sort {
                        var time1: Int
                        var time2: Int
                        print($0.time, $1.time)
                        if ($0.time == "Leaving") {
                            time1 = 0
                        } else {
                            time1 = Int($0.time)  as! Int
                        }
                        if ($1.time == "Leaving") {
                            time2 = 0
                        } else {
                            time2 = Int($1.time) as! Int
                        }
                        
                        
                        print(time1, time2)
                        return time1 < time2
                    }
                    self.trains = results
                }
            } else {
                print("fetching trips from", self.fromStation.abbr, "to", self.toStation.abbr )
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                print(baseURL + "/api/v2/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr)
                Alamofire.request(baseURL + "/api/v2/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr, headers: headers).responseJSON { response in
                    //  print(JSON(response.value))
                    let estimates = JSON(JSON(response.value)["trips"].arrayValue)
                    //   print(estimates.count)
                    var results: Array = [Train]()
                    
                    for x in 0...estimates.count - 1 {
                        let thisTrain = estimates[x]
                        let etd = thisTrain["@origTimeMin"].stringValue
                        let eta = thisTrain["@destTimeMin"].stringValue
                        let direction = thisTrain["leg"][0]["@trainHeadStation"].stringValue
                        
                        //let color = thisTrain["color"].stringValue
                        let color = "none"
                        print(eta)
                        results.append(Train(id: UUID(), direction: direction, time: etd, unit: "", color: "none", cars: 0, hex: "0", eta: eta))
                    }
                    
                    results.sort {
                        $0.time < $1.time
                    }
                    self.trains = results
                }
            }
            
        } else {
            print("cycling failed due to invalid data")
            let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(cylce), userInfo: nil, repeats: false)
            
        }
    }
    private func start() {
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
    }
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            getClosestStations()
        }
    }
    func getClosestStations() {
        if (!stations.isEmpty && lat != 0.0 && long != 0.0) {
            let locChange = lat != lastLat || long != lastLong
            if locChange {
                lastLong = long
                lastLat = lat
                print("getting nearest station")
                let myCord: CLLocation = CLLocation(latitude: lat, longitude: long)
                let testingStations = self.stations.sorted {
                    let station1Loc: CLLocation = CLLocation(latitude: $0.lat, longitude: $0.long)
                    let station2Loc: CLLocation = CLLocation(latitude: $1.lat, longitude: $1.long)
                    let distance1Miles = myCord.distance(from: station1Loc)
                    let distance2Miles = myCord.distance(from: station2Loc)
                    return distance1Miles < distance2Miles
                }
                if (self.closestStations.isEmpty || testingStations[0].name != self.closestStations[0].name) {
                    self.toStationSuggestions = testingStations
                    self.toStationSuggestions.insert(Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0), at: 0)
                    self.closestStations = testingStations
                    print(self.closestStations)
                    if (self.goingOffClosestStation) {
                        self.fromStation = self.closestStations[0]
                        self.cylce()
                    }
                } else {
                    print("Stations calculated but no change in order")
                }
            } else {
                print("no loc change")
            }
            
        } else {
            print("getting nearest station FAILED due to lack of info")
        }
    }
    func getStationsFromApi() {
        print("getting stations from api")
        Alamofire.request(baseURL + "/api/v3/stations")
            .responseJSON{
                response in print(response)
                if  response.value != nil {
                    let stationJSON = JSON(response.value)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationModel")
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    for i in 0..<stationJSON["stations"].arrayValue.count {
                        let json = stationJSON["stations"][i]
                        let id = json["_id"].stringValue
                        let name = json["name"].stringValue
                        let abbr = json["abbr"].stringValue
                        let lat = json["gtfs_latitude"].doubleValue
                        let long = json["gtfs_longitude"].doubleValue
                        let entity = NSEntityDescription.entity(forEntityName: "StationModel", in: context)
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
                        self.stations.append(Station(id:id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue))
                        
                    }
                    //   print(self.stations)
                    
                    print("got stations from server")
                    self.getClosestStations()
                    
                } else {
                    print("error retreving stations")
                    self.network = false
                }
        }
    }
    func getStations() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StationModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var stations: [Station] = []
            var version: Int = 0
            for data in result as! [NSObject] {
                let name = data.value(forKey: "name") as! String
                let abbr = data.value(forKey: "abbr") as! String
                let id = data.value(forKey: "id") as! String
                let lat = data.value(forKey: "lat") as! Double
                let long = data.value(forKey: "long") as! Double
                stations.append(Station(id: id,name: name,lat: lat,long: long,abbr: abbr, version: data.value(forKey: "version") as! Int))
                version = data.value(forKey: "version") as! Int
            }
            print(stations, version)
            if (stations.isEmpty) {
                print("no coredata stations")
                getStationsFromApi()
            } else {
                self.stations = stations
                print("got stations from core data")
                getClosestStations()
            }
        }
        catch {
            print("failed to get stations from core data")
            getStationsFromApi()
        }
        
    }
    func load() {
        print ("load func ran")
    }
    func loginFromWeb(passphrase: String) {
        print("logging in from web", passphrase)
        let headers: HTTPHeaders = [
            "Authorization": passphrase,
            "Accept": "application/json"
        ]
        Alamofire.request("https://api.arrival.city/api/v2/login", headers: headers).responseJSON {
            response in //print(response.value)
            if  response.value != nil {
                let jsonResponse = JSON(response.value)
                if jsonResponse["user"].stringValue == "true" {
                    self.auth = true
                    self.ready = true
                    self.passphrase = passphrase
                    print("user authorized")
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    let newUser = NSManagedObject(entity: entity!, insertInto: context)
                    newUser.setValue(passphrase, forKey: "pass")
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                } else {
                    print("user not authorized")
                    self.auth = false
                    self.passphrase = ""
                    self.ready = true
                    //TODO handle showing error
                }
            } else {
                print("error logging in")
                // self.network = false
                // self.ready = true
            }
        }
    }
    func login() {
        print("logging in")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            if (result.isEmpty) {
                self.ready = true
                self.auth = false
                
            } else {
                
                let nsResult = result as! [NSObject]
                let passphraseToTest = nsResult[0].value(forKey: "pass") as! String
                print(passphraseToTest, "passphrase to  test login with")
                let headers: HTTPHeaders = [
                    "Authorization": passphraseToTest,
                    "Accept": "application/json"
                ]
                Alamofire.request("https://api.arrival.city/api/v2/login", headers: headers).responseJSON {
                    response in //print(response.value)
                    if  response.value != nil {
                        let jsonResponse = JSON(response.value)
                        if jsonResponse["user"].stringValue == "true" {
                            self.auth = true
                            self.ready = true
                            print("user authorized")
                            self.passphrase = passphraseToTest
                        } else {
                            print("user not authorized")
                            self.auth = false
                            self.passphrase = ""
                            self.ready = true
                            //TODO remove core data storage of the invalid passphrase
                        }
                    } else {
                        print("error logging in")
                        // self.network = false
                        // self.ready = true
                    }
                }
                
            }
            
            
        }
        catch {}
    }
    
    
}
