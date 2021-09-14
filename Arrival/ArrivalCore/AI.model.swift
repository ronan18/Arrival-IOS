//
//  AI.model.swift
//  AI.model
//
//  Created by Ronan Furuta on 9/10/21.
//

import Foundation
import CoreML

public struct TripEvent: Hashable, Codable {
    public init(fromStation: Station, toStation: Station, date: Date) {
        self.toStation = toStation
        self.fromStation = fromStation
        self.date = date
    }
    var fromStation: Station
    var toStation: Station
    var date: Date
}
public struct StationProbibility {
   public let id: String
   public let prob: Double
}
public struct DirectionFilterEvent: Hashable, Codable {
    public init(fromStation: Station, direction: TrainDirection, date: Date) {
        self.direction = direction
        self.fromStation = fromStation
        self.date = date
    }
    var fromStation: Station
    var direction: TrainDirection
    var date: Date
}
