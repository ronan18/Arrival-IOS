//
//  Station Model.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

struct Station: Identifiable, Codable {
    let id: String
    var name: String
    var abbr: String
    var lat: Double? = nil
    var long: Double? = nil
}

struct StationStorage: Codable {
    var stations: [Station]
    var byAbbr: [String: Station]
    var version: Double
}
