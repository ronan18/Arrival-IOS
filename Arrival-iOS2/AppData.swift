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
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let baseURL = "https://api.arrival.city"
class AppData: ObservableObject {
    
    @Published var trains: String = ""
    @Published var passphrase: String = ""
    @Published var ready: Bool = false
    @Published var auth: Bool = false
    @Published var stations = [Station]()
    @Published var network = true
    
    init() {
        print("init function")
        getStations()
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
                    "Authorization": self.passphrase,
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
