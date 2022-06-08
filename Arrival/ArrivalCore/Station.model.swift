//
//  Station.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/23/21.
//

import Foundation
public struct Station: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var abbr: String
    public var lat: Double? = nil
    public var long: Double? = nil
    public var firstFive = false
    public init(id: String, name: String,abbr: String, lat: Double? = nil,long: Double? = nil) {
        self.id = id
        self.name = name
        self.abbr = abbr
        self.lat = lat
        self.long = long
    }
}

public struct StationStorage: Codable {
    public var stations: [Station]
    public var byAbbr: [String: Station]
    public var version: Double
    public init(stations: [Station],byAbbr: [String: Station],version: Double) {
        self.stations = stations
        self.byAbbr = byAbbr
        self.version = version
    }
}
