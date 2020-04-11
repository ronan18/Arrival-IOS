//
//  AppData.swift
//  ArrivalWatchOS Extension
//
//  Created by Ronan Furuta on 4/10/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
let defaults = UserDefaults.standard
class AppData: NSObject, ObservableObject,CLLocationManagerDelegate {
    @Published var text: String = defaults.string(forKey: "passphrase") ?? "none"
    override init() {
        print("int")
    }
}
