//
//  Trip.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/23/21.
//

import Foundation
public struct Trip: Identifiable {
    public let id: String
    public let origin: Station
    public let destination: Station
    public let originTime: Date
    public let destinationTime: Date
    public let tripTime: TimeInterval
    public let legs: [TripLeg]
    public init (id: String, origin: Station, destination: Station, originTime: Date, destinationTime: Date,tripTime: TimeInterval,legs: [TripLeg]) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.originTime = originTime
        self.destinationTime = destinationTime
        self.tripTime = tripTime
        self.legs = legs
    }
    
}

public struct TripLeg: Identifiable {
    public let id = UUID()
    public var order: Int
    public var origin: String
    public var destination: String
    public let originTime: Date
    public let destinationTime: Date
    public let route: Route
    public var trainHeadSTN: String
    public var stopCount: Int
    public var enrouteTime: TimeInterval
    public var finalLeg: Bool
    public init(order: Int, origin: String, destination: String, originTime: Date, destinationTime: Date, route: Route, trainHeadSTN: String, finalLeg: Bool = false) {
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

public struct Route: Identifiable {
    public let id = UUID()
    public let routeNumber: Int
    public let name: String
    public let abbr: String
    public let origin: String
    public let destination: String
    public let direction: TrainDirection
    public let color: TrainColor
    public let stationCount: Int
    public let stations: [String]
    public init(routeNumber: Int, name: String,abbr: String, origin: String, destination: String, direction: TrainDirection, color: TrainColor, stationCount: Int, stations: [String]) {
        self.routeNumber = routeNumber
        self.name = name
        self.abbr = abbr
        self.origin = origin
        self.destination = destination
        self.direction = direction
        self.color = color
        self.stationCount = stationCount
        self.stations = stations
    }
}
