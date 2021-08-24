//
//  ArrivalAPI.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/22/21.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

public class ArrivalAPI {
    public var auth: String? = nil
    public var authorized = false
    var apiURL = "https://api.arrival.city"
    public init(auth: String? = nil, authorized: Bool = false, apiUrl: String = "https://api.arrival.city") {
        self.auth = auth
        self.authorized = authorized
        self.apiURL = apiUrl
    }
    public func stations() async  -> (StationStorage?) {
        let response = await withCheckedContinuation { cont in
            AF.request("\(self.apiURL)/api/v3/stations").responseJSON { response in
                cont.resume(returning: response)
            }
        }
        switch response.result {
        case .success(let value):
            var result:JSON = []
            result = JSON(value)
            var stations: [Station] = []
            var stationsByAbbr: [String: Station] = [:]
            result["stations"].arrayValue.forEach { station in
                stations.append(Station(id: station["_id"].stringValue, name: station["name"].stringValue, abbr: station["abbr"].stringValue, lat: station["gtfs_latitude"].doubleValue, long: station["gtfs_longitude"].doubleValue))
            }
            stations.forEach( {station in
                stationsByAbbr[station.abbr] = station
            })
            return(StationStorage(stations: stations, byAbbr: stationsByAbbr, version: result["version"].doubleValue))
        case .failure(let error):
            print(error)
            return nil
        }
    }
    public func login(auth: String) async -> (Bool) {
        let headers: HTTPHeaders = [
            "Authorization": auth,
            "Accept": "application/json"
        ]
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v2/login", headers: headers).responseJSON { response in
                cont.resume(returning: response)
            }
        }
        //   print(response)
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            if (result["user"].boolValue) {
                self.auth = auth
                self.authorized = true
                return true
            } else {
                self.auth = auth
                return false
            }
            
        case .failure(let error):
            print(error)
            return false
        }
        
    }
    public func createAccount(auth: String) async throws -> Bool {
        enum ValidationError: Error {
            case apiError
            case requestError
            //   case nameToShort(nameLength: Int)
        }
        let headers: HTTPHeaders = [
            "Authorization": auth,
            "Accept": "application/json"
        ]
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v2/createaccount", method: .post, parameters: ["passphrase":auth], headers: headers).responseJSON{ response in
                cont.resume(returning: response)
            }
        }
        print(response)
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            if (result["success"].boolValue) {
                self.auth = auth
                return true
            } else {
                //  self.auth = auth
                throw ValidationError.apiError
                return  false
            }
            
        case .failure(let error):
            print(error)
            throw ValidationError.requestError
            // return false
        }
        
    }
    public func trip(byID: String) async throws -> (Trip?) {
        enum ValidationError: Error {
            case notAuthorized
            case requestError
            case tripDoesNotExist
            //   case nameToShort(nameLength: Int)
        }
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
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v3/trip/\(byID)", headers: headers).responseJSON { response in
                cont.resume(returning: response)
            }
        }
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            //  print(result)
            var routes: [Int: Route] = [:]
            // var trip: Trip
            var legs: [TripLeg] = []
            if (result["trip"]["leg"].arrayValue.count > 0) {
                for (_, route) in result["routes"] {
                    //  print(key, route)
                    var stations: [String] = []
                    route["config"]["station"].arrayValue.forEach({station in
                        stations.append(station.stringValue)
                    })
                    routes[route["number"].intValue] = Route(routeNumber: route["number"].intValue, name: route["name"].stringValue, abbr: route["abbr"].stringValue, origin: route["oirgin"].stringValue, destination: route["destination"].stringValue, direction: determineTrainDirection(route["direction"].stringValue), color: determineTrainColor(route["color"].stringValue), stationCount: route["num_stns"].intValue, stations: stations)
                    
                }
                result["trip"]["leg"].arrayValue.forEach({leg in
                    //print(leg)
                    /*  print(convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue))*/
                    
                    legs.append(TripLeg(order: leg["@order"].intValue, origin: leg["@origin"].stringValue, destination: leg["@destination"].stringValue, originTime: convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue)!, destinationTime: convertBartDate(time: leg["@destTimeMin"].stringValue, date: leg["@destTimeDate"].stringValue)!, route: routes[leg["route"].intValue]!, trainHeadSTN: leg["@trainHeadStation"].stringValue, finalLeg: false))
                    
                })
                legs[legs.count - 1].finalLeg = true
                let originTime = convertBartDate(time: result["trip"]["@origTimeMin"].stringValue, date: result["trip"]["@origTimeDate"].stringValue)!
                
                let destTime = convertBartDate(time: result["trip"]["@destTimeMin"].stringValue, date: result["trip"]["@destTimeDate"].stringValue)!
                
                let resultTrip = Trip(id: byID, origin: Station(id: result["trip"]["@origin"].stringValue, name: result["trip"]["@origin"].stringValue, abbr: result["trip"]["@origin"].stringValue), destination: Station(id: result["trip"]["@destination"].stringValue, name: result["trip"]["@destination"].stringValue, abbr: result["trip"]["@destination"].stringValue), originTime: originTime , destinationTime: destTime, tripTime: destTime.timeIntervalSince(originTime), legs: legs)
                
                return resultTrip
            } else {
                throw ValidationError.tripDoesNotExist
                //  return (nil)
            }
        case .failure(let error):
            print(error)
            throw ValidationError.requestError
            // return (nil)
        }
    }
    public func getTrainsFrom(from: Station, timeConfig: TripTime) async throws -> ([Train]?) {
        enum ValidationError: Error {
            case notAuthorized
            case apiError
            //   case nameToShort(nameLength: Int)
        }
        guard self.authorized else {
            throw ValidationError.notAuthorized
            
        }
        guard self.auth != nil else {
            throw ValidationError.notAuthorized
        }
        
        let headers: HTTPHeaders = [
            "Authorization": auth!,
            "Accept": "application/json"
        ]
        
      let response = await withCheckedContinuation { cont in
          /*AF.request("\(apiURL)/api/v3/trains/\(from.abbr)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
              
              cont.resume(returning: response)
          } */
          AF.request("\(apiURL)/api/v3/trip/\(from.abbr)", headers: headers).responseJSON { response in
              cont.resume(returning: response)
          }
          
        }
       /* let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v3/trains/\(from.abbr)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                cont.resume(returning: response)
            }
        }*/
        /*switch response.result {
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
            return trains
            
        case .failure(let error):
            print(error)
            throw ValidationError.apiError
        }*/
        
        return nil
    }
}



