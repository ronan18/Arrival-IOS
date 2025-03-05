//
//  StopsDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation


public struct StationsDB: Codable, Sendable {
    let stations: [String: Stop]
    var all: [Stop] {
        return Array(self.stations.values)
    }
    init() {
        self.stations = [:]
    }
    init(from stops: [Stop]) {
        let all = stops.filter({ stop in
            return stop.locationType == .stop
        })
        var stations: [String: Stop] = [:]
        all.forEach({stop in
            stations[stop.id] = stop
        })
        
        self.stations = stations
    }
}
