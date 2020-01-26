//
//  Station.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/22/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

struct Station : Codable,Identifiable {
    var id: String
    var name: String
    var lat: Double
    var long: Double
    var abbr: String
    var version: Int
}
