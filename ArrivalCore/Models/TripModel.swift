//
//  TripModel.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

struct Trip: Identifiable {
    let id: String
    let origin: Station
    let destination: Station
    let originTime: Date
    let destinationTime: Date
    let tripTime: TimeInterval
    let legs: [TripLeg]
    
}

struct TripLeg: Identifiable {
    let id = UUID()
    var order: Int
    var origin: String
    var destination: String
    let originTime: Date
    let destinationTime: Date
    let route: Route
    var trainHeadSTN: String
    var stopCount: Int
    var enrouteTime: TimeInterval
    var finalLeg: Bool
    init(order: Int, origin: String, destination: String, originTime: Date, destinationTime: Date, route: Route, trainHeadSTN: String, finalLeg: Bool = false) {
        self.order = order
        self.origin = origin
        self.destination = destination
        self.originTime = originTime
        self.destinationTime = destinationTime
        self.route = route
        
        let startIndex = self.route.stations.firstIndex(of: origin)
        let endIndex = self.route.stations.firstIndex(of: destination)
        if let startIndex = startIndex, let endIndex = endIndex {
              self.stopCount = endIndex - startIndex
        } else {
            self.stopCount = 0
            print("error generating stop count")
        }
        self.enrouteTime = destinationTime.timeIntervalSince(originTime)
        self.trainHeadSTN = trainHeadSTN
        self.finalLeg = finalLeg
        
    }
}

struct Route: Identifiable {
    let id = UUID()
    let routeNumber: Int
    let name: String
    let abbr: String
    let origin: String
    let destination: String
    let direction: TrainDirection
    let color: TrainColor
    let stationCount: Int
    let stations: [String]
}
