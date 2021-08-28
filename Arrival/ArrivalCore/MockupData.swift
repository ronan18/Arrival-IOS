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
}
