//
//  AI.model.swift
//  AI.model
//
//  Created by Ronan Furuta on 9/10/21.
//

import Foundation

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
