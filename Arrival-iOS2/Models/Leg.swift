//
//  Leg.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct Leg: Identifiable, Codable {
    var id = UUID()
    var order: Int
    var origin: String
    var destination: String
    var originTime: String
    var destinationTime: String
    var line: String
    var route: Int
    var trainDestination: String
    var color: String
    var stops: Int
}
