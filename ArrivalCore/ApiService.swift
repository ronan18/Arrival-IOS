//
//  ApiService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import Alamofire
import Combine
import NotificationCenter
import SwiftyJSON
class ApiService {
    
    var auth: String?
    let apiUrl = "https://api.arrival.city"
    func  getStations(handleComplete: @escaping (([Station])->())) {
        print("get stations")
        var result:JSON = []
        
        AF.request("\(apiUrl)/api/v3/stations").responseJSON { response in
            switch response.result {
            case .success(let value):
                result = JSON(value)
                // print(result)
                var stations: [Station] = []
                result["stations"].arrayValue.forEach { station in
                    stations.append(Station(id: station["_id"].stringValue, name: station["name"].stringValue, abbr: station["abbr"].stringValue, lat: station["gtfs_latitude"].doubleValue, long: station["gtfs_longitude"].doubleValue))
                }
                
                handleComplete(stations)
            case .failure(let error):
                print(error)
            }
            
        }
        
        
        
        
        
    }
    func login(key: String, handleComplete: @escaping ((_ authorized: Bool)->())) {
        let headers: HTTPHeaders = [
            "Authorization": key,
            "Accept": "application/json"
        ]
        AF.request("\(apiUrl)/api/v2/login", headers: headers).responseJSON { response in
            //   print(response)
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                if (result["user"].boolValue) {
                    self.auth = key
                    handleComplete(true)
                } else {
                    self.auth = key
                    handleComplete(false)
                }
                
            case .failure(let error):
                print(error)
                handleComplete(false)
            }
            
        }
    }
    func getTrainsFrom(from: Station, type: String, time: String, handleComplete: @escaping (([Train])->())) {
        if let auth = auth {
            let headers: HTTPHeaders = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
            AF.request("\(apiUrl)/api/v3/trains/\(from.abbr)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                switch response.result {
                case .success(let value):
                    let result = JSON(value)
                    var trains: [Train] = []
                    result["estimates"]["etd"].arrayValue.forEach {destinationTrains in
                        let destinationTrainsJSON = JSON(destinationTrains)
                        let destination = Station(id: destinationTrainsJSON["abbreviation"].stringValue, name: destinationTrainsJSON["destination"].stringValue, abbr: destinationTrainsJSON["abbreviation"].stringValue)
                        //print(destination)
                        let estimates = destinationTrainsJSON["estimate"].arrayValue
                        //  print(estimates.count)
                        estimates.forEach {trainEstimate in
                            let etd = Date(timeIntervalSinceNow: trainEstimate["etd"].doubleValue * 60)
                            let train = Train(departureStation: from, destinationStation: destination, etd: etd, platform: trainEstimate["platform"].intValue, direction: determineTrainDirection(trainEstimate["direction"].stringValue), delay: trainEstimate["delay"].doubleValue, bikeFlag: trainEstimate["bikeflag"].intValue, color: determineTrainColor(trainEstimate["color"].stringValue))
                            //print(train)
                            trains.append(train)
                        }
                    }
                    handleComplete(trains)
                    
                case .failure(let error):
                    print(error)
                    handleComplete([])
                }
            }
        } else {
            print("no auth", auth)
        }
        
    }
    func createAccount(key: String, handleComplete: @escaping ((Bool)->())) {
        let headers: HTTPHeaders = [
            "Authorization": key,
            "Accept": "application/json"
        ]
        AF.request("\(apiUrl)/api/v2/createaccount", method: .post, parameters: ["passphrase":key], headers: headers).responseJSON{ response in
            print(response)
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                if (result["success"].boolValue) {
                    self.auth = key
                    handleComplete(true)
                } else {
                    self.auth = key
                    handleComplete(false)
                }
                
            case .failure(let error):
                print(error)
                handleComplete(false)
            }
            
        }
    }
    func getTrip(byID: String,handleComplete: @escaping ((Trip?)->()) ) {
        var headers: HTTPHeaders
        if let auth = self.auth {
            headers = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
        } else {
            headers = [
                "Authorization": "guest",
                "Accept": "application/json"
            ]
        }
        AF.request("\(apiUrl)/api/v3/trip/\(byID)", headers: headers).responseJSON { response in
          //  print(response)
            switch response.result {
            case .success(let value):
                let result = JSON(value)
              //  print(result)
                var routes: [Int: Route] = [:]
                var trip: Trip
                var legs: [TripLeg] = []
                for (key, route) in result["routes"] {
                  //  print(key, route)
                    var stations: [String] = []
                    route["config"]["station"].arrayValue.forEach({station in
                        stations.append(station.stringValue)
                    })
                    routes[route["number"].intValue] = Route(routeNumber: route["number"].intValue, name: route["name"].stringValue, abbr: route["abbr"].stringValue, origin: route["oirgin"].stringValue, destination: route["destination"].stringValue, direction: determineTrainDirection(route["direction"].stringValue), color: determineTrainColor(route["color"].stringValue), stationCount: route["num_stns"].intValue, stations: stations)
                    
                }
                
          //  print(routes, "routes")
                
                
                result["trip"]["leg"].arrayValue.forEach({leg in
                    //print(leg)
                  /*  print(convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue))*/
                    
                    legs.append(TripLeg(order: leg["@order"].intValue, origin: leg["@origin"].stringValue, destination: leg["@destination"].stringValue, originTime: convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue)!, destinationTime: convertBartDate(time: leg["@destTimeMin"].stringValue, date: leg["@destTimeDate"].stringValue)!, route: routes[leg["route"].intValue]!))
                    
                })
                let originTime = convertBartDate(time: result["trip"]["@origTimeMin"].stringValue, date: result["trip"]["@origTimeDate"].stringValue)!
                
                let destTime = convertBartDate(time: result["trip"]["@destTimeMin"].stringValue, date: result["trip"]["@destTimeDate"].stringValue)!
                
                let resultTrip = Trip(id: byID, origin: Station(id: result["trip"]["@origin"].stringValue, name: result["trip"]["@origin"].stringValue, abbr: result["trip"]["@origin"].stringValue), destination: Station(id: result["trip"]["@destination"].stringValue, name: result["trip"]["@destination"].stringValue, abbr: result["trip"]["@destination"].stringValue), originTime: originTime , destinationTime: destTime, tripTime: destTime.timeIntervalSince(originTime), legs: legs)

                handleComplete(resultTrip)
                
            case .failure(let error):
                print(error)
                handleComplete(nil)
            }
        }
    }
    func getRoute(from: String, to: String, type: String, time: String, handleComplete: @escaping (()->())) {
        if let auth = auth {
            let headers: HTTPHeaders = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
            AF.request("\(apiUrl)/api/v4/routes/\(from)/\(to)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                print(response)
                handleComplete()
            }
        } else {
            print("no auth", auth)
        }
    }
    
    
}
