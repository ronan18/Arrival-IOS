//
//  Trip.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct TripInfo: Identifiable, Codable {
    var id = UUID()
    var origin: String
    var destination: String
    var legs: [Leg]
    var originTime: String
    var originDate: String
    var destinatonTime: String
    var destinatonDate: String
    var tripTIme: Double
    var leavesIn: Int
   
}
