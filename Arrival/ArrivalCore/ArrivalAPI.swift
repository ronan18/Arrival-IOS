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
    public func stations() async throws  -> (StationStorage) {
        
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
            throw APIError.requestError
            // return nil
        }
    }
    public func login(auth: String) async throws -> (Bool) {
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
                // self.auth = auth
                self.authorized = false
                throw APIError.notAuthorized
                // return false
                
            }
            
        case .failure(let error):
            print(error)
            throw APIError.requestError
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
                throw APIError.apiError
                //return  false
            }
            
        case .failure(let error):
            print(error)
            throw APIError.requestError
            // return false
        }
        
    }
    public func trip(byID: String) async throws -> (Trip?) {
        
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
                throw APIError.requestedPropertyDoesntExist
                //  return (nil)
            }
        case .failure(let error):
            print(error)
            throw APIError.requestError
            // return (nil)
        }
    }
    public func trainsFrom(from: Station, timeConfig: TripTime) async throws -> ([Train], [Train], [Train]) {
        
        guard self.authorized else {
            throw APIError.notAuthorized
            
        }
        guard self.auth != nil else {
            throw APIError.notAuthorized
        }
        
        let headers: HTTPHeaders = [
            "Authorization": auth!,
            "Accept": "application/json"
        ]
        
        
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v3/trains/\(from.abbr)", method: .post, parameters: ["type": timeConfig.type.rawValue, "time": timeConfig.iso], headers: headers).responseJSON { response in
                cont.resume(returning: response)
            }
        }
        
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            var north: [Train] = []
            var south: [Train] = []
            var trains: [Train] = []
            result["estimates"]["etd"].arrayValue.forEach {destinationTrains in
                let destinationTrainsJSON = JSON(destinationTrains)
                let destination = Station(id: destinationTrainsJSON["abbreviation"].stringValue, name: destinationTrainsJSON["destination"].stringValue, abbr: destinationTrainsJSON["abbreviation"].stringValue)
                let estimates = destinationTrainsJSON["estimate"].arrayValue
                estimates.forEach {trainEstimate in
                    let etd = Date(timeIntervalSinceNow: trainEstimate["minutes"].doubleValue * 60)
                    let direction = determineTrainDirection(trainEstimate["direction"].stringValue)
                  
                    let train = Train(departureStation: from, destinationStation: destination, etd: etd, platform: trainEstimate["platform"].intValue, direction: direction, delay: trainEstimate["delay"].doubleValue, bikeFlag: trainEstimate["bikeflag"].intValue, color: determineTrainColor(trainEstimate["color"].stringValue), cars: trainEstimate["length"].intValue)
                    switch direction {
                    case .north:
                        north.append(train)
                    case .south:
                        south.append(train)
                    }
                    trains.append(train)
                }
            }
            trains.sort(by: {(a,b) in
                return a.etd < b.etd
            })
            north.sort(by: {(a,b) in
                return a.etd < b.etd
            })
            south.sort(by: {(a,b) in
                return a.etd < b.etd
            })
            return (trains, north, south)
        case .failure(let error):
            print(error)
            throw APIError.apiError
        }
        
        //return  nil
    }
    public func trips(from: Station, to: Station, timeConfig: TripTime) async throws -> ([Trip]) {
        
        guard self.authorized else {
            throw APIError.notAuthorized
            
        }
        guard self.auth != nil else {
            throw APIError.notAuthorized
        }
        let headers: HTTPHeaders = [
            "Authorization": auth!,
            "Accept": "application/json"
        ]
        print("API REQUEST: \(apiURL)/api/v5/routes/\(from.abbr)/\(to.abbr)", ["type": timeConfig.type.rawValue, "time": timeConfig.iso], headers)
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v5/routes/\(from.abbr)/\(to.abbr)", method: .post, parameters: ["type": timeConfig.type.rawValue, "time": timeConfig.iso], headers: headers).responseJSON{ response in
                cont.resume(returning: response)
            }
        }
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            //print(result)
            let tripsJSON = result["trips"]
            if (tripsJSON.arrayValue.count > 0) {
                var resultTrips: [Trip] = []
                var routes: [Int: Route] = [:]
                for (_, route) in result["routes"] {
                    //  print(key, route)
                    var stations: [String] = []
                    route["config"]["station"].arrayValue.forEach({station in
                        stations.append(station.stringValue)
                    })
                    routes[route["number"].intValue] = Route(routeNumber: route["number"].intValue, name: route["name"].stringValue, abbr: route["abbr"].stringValue, origin: route["oirgin"].stringValue, destination: route["destination"].stringValue, direction: determineTrainDirection(route["direction"].stringValue), color: determineTrainColor(route["color"].stringValue), stationCount: route["num_stns"].intValue, stations: stations)
                    
                }
                tripsJSON.arrayValue.forEach({trip in
                    var legs: [TripLeg] = []
                    var error = false
                    trip["leg"].arrayValue.forEach({leg in
                        //print(leg)
                        /*  print(convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue))*/
                       // print("DEBUG START")
                      // print(leg["route"].intValue)
                       // print(routes)
                       // print(routes[leg["route"].intValue])
                       let routeLeg = routes[leg["route"].intValue] ?? Route(routeNumber: 0, name: "ERROR", abbr: "TEST", origin: "TEST", destination: "TEST", direction: .north, color: .black, stationCount: 0, stations: [])
                        
                        legs.append(TripLeg(order: leg["@order"].intValue, origin: leg["@origin"].stringValue, destination: leg["@destination"].stringValue, originTime: convertBartDate(time: leg["@origTimeMin"].stringValue, date: leg["@origTimeDate"].stringValue)!, destinationTime: convertBartDate(time: leg["@destTimeMin"].stringValue, date: leg["@destTimeDate"].stringValue)!, route: routeLeg, trainHeadSTN: leg["@trainHeadStation"].stringValue))
                        if routeLeg.name == "ERROR" {
                            error = true
                        }
                        
                    })
                    if (error) {
                        print(trip, result)
                    }
                    legs[legs.count - 1].finalLeg = true
                    for i in 0..<legs.count {
                        guard !legs[i].finalLeg  else {
                            break
                        }
                        legs[i].transferWindow = legs[i + 1].originTime.timeIntervalSince(legs[i].destinationTime)
                    }
                    let originTime = convertBartDate(time: trip["@origTimeMin"].stringValue, date: trip["@origTimeDate"].stringValue)!
                   // print("API: origin time converted", originTime,trip["@origTimeMin"].stringValue )
                    let destTime = convertBartDate(time: trip["@destTimeMin"].stringValue, date: trip["@destTimeDate"].stringValue)!
                    //print("API: dest time converted", destTime,trip["@destTimeMin"].stringValue )

                    let resultTrip = Trip(id: trip["tripId"].stringValue, origin: Station(id: trip["@origin"].stringValue, name: trip["@origin"].stringValue, abbr: trip["@origin"].stringValue), destination: Station(id: trip["@destination"].stringValue, name: trip["@destination"].stringValue, abbr: trip["@destination"].stringValue), originTime: originTime , destinationTime: destTime, tripTime: destTime.timeIntervalSince(originTime), legs: legs)
                    resultTrips.append(resultTrip)
                })
                if (timeConfig.type == .arrive) {
                resultTrips.sort {a,b in
                    return a.originTime > b.originTime
                }
                }
                return resultTrips
            } else {
                return []
            }
        case .failure(let error):
            print(error)
            throw APIError.apiError
        }
    }
    public func alerts(verbose: Bool = false) async throws -> ([BARTAlert], String?){
        guard self.authorized else {
            throw APIError.notAuthorized
            
        }
        guard self.auth != nil else {
            throw APIError.notAuthorized
        }
        let headers: HTTPHeaders = [
            "Authorization": auth!,
            "Accept": "application/json",
            "verbose": verbose ? "true" : "false"
        ]
        print("API REQUEST: \(apiURL)/api/v5/advisories", headers)
        let response = await withCheckedContinuation { cont in
            AF.request("\(apiURL)/api/v5/advisories", method: .get, headers: headers).responseJSON{ response in
                cont.resume(returning: response)
            }
        }
        //print(response)
        switch response.result {
        case .success(let value):
            let result = JSON(value)
            guard let alerts = result["alerts"].array else {
                throw APIError.requestError
            }
            var message = result["message"].string
            if message?.count == 0 {
                message = nil
            }
            var alertsResult: [BARTAlert] = []
            alerts.forEach {alertJSON in
                alertsResult.append(BARTAlert(station: alertJSON["station"].string ?? "", description: alertJSON["description"].string ?? ""))
            }
            print(alertsResult)
            return (alertsResult, message)
        case .failure(let error):
            print(error)
            throw APIError.apiError
        }
        
    }
}



