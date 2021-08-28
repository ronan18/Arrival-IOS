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
    public var train: Train = Train(departureStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), destinationStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), etd: <#T##Date#>, platform: <#T##Int#>, direction: <#T##TrainDirection#>, delay: <#T##Double#>, bikeFlag: <#T##Int#>, color: <#T##TrainColor#>, cars: <#T##Int#>)
}
