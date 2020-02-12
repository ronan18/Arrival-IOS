//
//  Route.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/11/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct Route: Identifiable, Codable {
    var id = UUID()
    var name: String
    var abbr: String
    var routeID: String
    var origin: String
    var destination: String
    var direction: String
    var color: String
    var stations: [String]
}
