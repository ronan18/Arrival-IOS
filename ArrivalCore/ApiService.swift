//
//  ApiService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import Alamofire

class ApiService {
    
    var auth: String?
    let apiUrl = "https://api.arrival.city"
    func  getStations() {
        Alamofire.request("\(apiUrl)/api/v3/stations").responseJSON { response in
            print(response)
        }
    }
    func login(key: String, handleComplete: @escaping (()->())) {
        let headers: HTTPHeaders = [
            "Authorization": key,
            "Accept": "application/json"
        ]
        Alamofire.request("\(apiUrl)/api/v2/login", headers: headers).responseJSON { response in
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
            Alamofire.request("\(apiUrl)/api/v3/trains/\(from)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
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
        Alamofire.request("\(apiUrl)/api/v2/createaccount", method: .post, parameters: ["passphrase":key], headers: headers).responseJSON{ response in
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
        Alamofire.request("\(apiUrl)/api/v3/trip/tripid", headers: headers).responseJSON { response in
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
            Alamofire.request("\(apiUrl)/api/v4/routes/\(from)/\(to)", method: .post, parameters: ["type": type, "time": time], headers: headers).responseJSON{ response in
                print(response)
                handleComplete()
            }
        } else {
            print("no auth", auth)
        }
    }
    
    
}
