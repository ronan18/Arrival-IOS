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
    var authorized: Bool = false
    let apiUrl = "https://api.arrival.city"
    func  getStations(handleComplete: @escaping ((StationStorage)->())) {
        var result:JSON = []
        
        AF.request("\(apiUrl)/api/v3/stations").responseJSON { response in
            switch response.result {
            case .success(let value):
                result = JSON(value)
                // print(result)
                var stations: [Station] = []
                var stationsByAbbr: [String: Station] = [:]
                result["stations"].arrayValue.forEach { station in
                    stations.append(Station(id: station["_id"].stringValue, name: station["name"].stringValue, abbr: station["abbr"].stringValue, lat: station["gtfs_latitude"].doubleValue, long: station["gtfs_longitude"].doubleValue))
                }
                stations.forEach( {station in
                    stationsByAbbr[station.abbr] = station
                })
                
                handleComplete(StationStorage(stations: stations, byAbbr: stationsByAbbr, version: result["version"].doubleValue))
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
                    self.authorized = true
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
                if (result["trip"]["leg"].arrayValue.count > 0) {
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
                        
                        legs.append(TripLeg(order: leg["@order"].intValue, origin: leg["@origin"].stringValue, destination: leg["@destination"].stringValue, originTime: convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue)!, destinationTime: convertBartDate(time: leg["@destTimeMin"].stringValue, date: leg["@destTimeDate"].stringValue)!, route: routes[leg["route"].intValue]!, trainHeadSTN: leg["@trainHeadStation"].stringValue))
                        
                    })
                    let originTime = convertBartDate(time: result["trip"]["@origTimeMin"].stringValue, date: result["trip"]["@origTimeDate"].stringValue)!
                    
                    let destTime = convertBartDate(time: result["trip"]["@destTimeMin"].stringValue, date: result["trip"]["@destTimeDate"].stringValue)!
                    
                    let resultTrip = Trip(id: byID, origin: Station(id: result["trip"]["@origin"].stringValue, name: result["trip"]["@origin"].stringValue, abbr: result["trip"]["@origin"].stringValue), destination: Station(id: result["trip"]["@destination"].stringValue, name: result["trip"]["@destination"].stringValue, abbr: result["trip"]["@destination"].stringValue), originTime: originTime , destinationTime: destTime, tripTime: destTime.timeIntervalSince(originTime), legs: legs)
                    
                    handleComplete(resultTrip)
                } else {
                    handleComplete(nil)
                }
            case .failure(let error):
                print(error)
                handleComplete(nil)
            }
        }
    }
    func conertTimeModelToAPIModel (_ timeConfig: TripTimeModel) -> [String] {
        var type: String
        var time: String = convertDateToISO(timeConfig.time)
        switch timeConfig.timeMode {
        case .arrive:
            type = "arrive"
        case .leave:
            type = "leave"
        case .now:
            type = "now"
        }
        return [type, time]
    }
    func getTrainsFrom(from: Station, timeConfig: TripTimeModel, handleComplete: @escaping (([Train]?)->())) {
        if let auth = auth {
            let headers: HTTPHeaders = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
            var type: String = conertTimeModelToAPIModel(timeConfig)[0]
            var time: String = conertTimeModelToAPIModel(timeConfig)[1]
            
            
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
                            // print("API: train etd addition", trainEstimate["minutes"])
                            let etd = Date(timeIntervalSinceNow: trainEstimate["minutes"].doubleValue * 60)
                            let train = Train(departureStation: from, destinationStation: destination, etd: etd, platform: trainEstimate["platform"].intValue, direction: determineTrainDirection(trainEstimate["direction"].stringValue), delay: trainEstimate["delay"].doubleValue, bikeFlag: trainEstimate["bikeflag"].intValue, color: determineTrainColor(trainEstimate["color"].stringValue), cars: trainEstimate["length"].intValue)
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
    func getTrips(from: Station, to: Station, timeConfig: TripTimeModel, handleComplete: @escaping (([Trip]?)->())) {
        if let auth = auth {
            let headers: HTTPHeaders = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
            var type: String = conertTimeModelToAPIModel(timeConfig)[0]
            var time: String = conertTimeModelToAPIModel(timeConfig)[1]
            AF.request("\(apiUrl)/api/v4/routes/\(from.abbr)/\(to.abbr)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                switch response.result {
                case .success(let value):
                    let result = JSON(value)
                    let tripsJSON = result["trips"]
                    if (tripsJSON.arrayValue.count > 0) {
                        var resultTrips: [Trip] = []
                        var routes: [Int: Route] = [:]
                        for (key, route) in result["routes"] {
                            //  print(key, route)
                            var stations: [String] = []
                            route["config"]["station"].arrayValue.forEach({station in
                                stations.append(station.stringValue)
                            })
                            routes[route["number"].intValue] = Route(routeNumber: route["number"].intValue, name: route["name"].stringValue, abbr: route["abbr"].stringValue, origin: route["oirgin"].stringValue, destination: route["destination"].stringValue, direction: determineTrainDirection(route["direction"].stringValue), color: determineTrainColor(route["color"].stringValue), stationCount: route["num_stns"].intValue, stations: stations)
                            
                        }
                        tripsJSON.arrayValue.forEach({trip in
                            var legs: [TripLeg] = []
                            trip["leg"].arrayValue.forEach({leg in
                                //print(leg)
                                /*  print(convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue))*/
                                
                                legs.append(TripLeg(order: leg["@order"].intValue, origin: leg["@origin"].stringValue, destination: leg["@destination"].stringValue, originTime: convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue)!, destinationTime: convertBartDate(time: leg["@destTimeMin"].stringValue, date: leg["@destTimeDate"].stringValue)!, route: routes[leg["route"].intValue]!, trainHeadSTN: leg["@trainHeadStation"].stringValue))
                                
                            })
                            let originTime = convertBartDate(time: trip["@origTimeMin"].stringValue, date: trip["@origTimeDate"].stringValue)!
                            print("API: origin time converted", originTime,trip["@origTimeMin"].stringValue )
                            let destTime = convertBartDate(time: trip["@destTimeMin"].stringValue, date: trip["@destTimeDate"].stringValue)!
                            
                            let resultTrip = Trip(id: trip["tripId"].stringValue, origin: Station(id: trip["@origin"].stringValue, name: trip["@origin"].stringValue, abbr: trip["@origin"].stringValue), destination: Station(id: trip["@destination"].stringValue, name: trip["@destination"].stringValue, abbr: trip["@destination"].stringValue), originTime: originTime , destinationTime: destTime, tripTime: destTime.timeIntervalSince(originTime), legs: legs)
                            resultTrips.append(resultTrip)
                        })
                        handleComplete(resultTrips)
                    } else {
                        handleComplete(nil)
                    }
                case .failure(let error):
                    print(error)
                    handleComplete(nil)
                }
            }
        } else {
            print("no auth", auth)
        }
    }
    
    
}
