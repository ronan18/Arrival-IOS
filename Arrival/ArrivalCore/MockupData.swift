//
//  MockupData.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/27/21.
//

import Foundation

public class MockUpData {
    public init() {}
    public var station: Station = Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil)
    public var train: Train = Train(departureStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), destinationStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), etd: Date(timeIntervalSinceNow: 5000), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red, cars: 10)
    public var trip: Trip = Trip(id: "test", origin: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), destination: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 600), tripTime: 7000, legs: [TripLeg(order: 2, origin: "ROCK", destination: "ROCK", originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 500), route: Route(routeNumber: 2, name: "", abbr: "", origin: "", destination: "", direction: .north, color: .red, stationCount: 20, stations: ["test", "test", "test"]), trainHeadSTN: "String")])
}
