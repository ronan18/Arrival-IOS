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
    func  getStations() -> [Station] {
        print("get stations")
        var result:JSON = []
        let semaphore = DispatchSemaphore(value: 0)
        AF.request("\(apiUrl)/api/v3/stations").responseJSON { response in
            switch response.result {
            case .success(let value):
                result = JSON(value)
               // print(result)
                semaphore.signal()
            case .failure(let error):
                print(error)
            }
            
        }
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        print("done with stations")
       
        var stations: [Station] = []
        result["stations"].arrayValue.forEach { station in
            stations.append(Station(id: station["_id"].stringValue, name: station["name"].stringValue, abbr: station["abbr"].stringValue, lat: station["gtfs_latitude"].doubleValue, long: station["gtfs_longitude"].doubleValue))
        }
        return stations
        
        
    }
    func login(key: String, handleComplete: @escaping (()->())) {
        let headers: HTTPHeaders = [
            "Authorization": key,
            "Accept": "application/json"
        ]
        AF.request("\(apiUrl)/api/v2/login", headers: headers).responseJSON { response in
            print(response)
            self.auth = key
            handleComplete()
        }
    }
    func getTrainsFrom(from: String, type: String, time: String) {
        if let auth = auth {
            let headers: HTTPHeaders = [
                "Authorization": auth,
                "Accept": "application/json"
            ]
            AF.request("\(apiUrl)/api/v3/trains/\(from)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                print(response)
            }
        } else {
            print("no auth", auth)
        }
        
    }
    func createAccount(key: String, handleComplete: @escaping (()->())) {
        let headers: HTTPHeaders = [
            "Authorization": key,
            "Accept": "application/json"
        ]
        AF.request("\(apiUrl)/api/v2/createaccount", method: .post, parameters: ["passphrase":key], headers: headers).responseJSON{ response in
            print(response)
            handleComplete()
        }
    }
    func getTrip(byID: String,handleComplete: @escaping (()->()) ) {
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
        AF.request("\(apiUrl)/api/v3/trip/tripid", headers: headers).responseJSON { response in
            print(response)
            
            handleComplete()
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
