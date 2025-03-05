//
//  RoutesDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation
public struct RoutesDB: Codable, Hashable, Equatable{
  
   
    
    public var all: [Route]
    
    private var byRouteIDIndex: [String: Int]
    private var byStopIDIndex: [String: [Int]]
    
   
    init() {
        self.all = []
        self.byRouteIDIndex = [:]
        self.byStopIDIndex = [:]
    }
    public init(from routes: [Route], trips: TripsDB, stations: StationsDB) {
        self.all = routes
        var inProgress: [String: Int] = [:]
        for i in 0..<routes.count {
            let route = all[i]
            inProgress[route.routeId] = i
        }
       
        self.byRouteIDIndex = inProgress
        
        var inProgressByStopID: [String: [Int]] = [:]
        stations.all.forEach({station in
            var routes: [Int] = []
            if let trips = trips.byStopID(station.stopId) {
                trips.forEach({trip in
                    if let route = inProgress[trip.routeId] {
                        if !routes.contains(route) {
                            routes.append(route)
                        }
                    }
                })
            }
            inProgressByStopID[station.stopId] = routes
        })
        
        self.byStopIDIndex = inProgressByStopID
        
    
    }
    
    public func byRouteID(_ routeID: String) -> Route? {
        guard let id = self.byRouteIDIndex[routeID] else {
            return nil
        }
        return self.all[id]
    }
    
    ///Shows all routes that a station has
    public func byStopID(_ stopId: String) -> [Route]? {
        guard let indexes = self.byStopIDIndex[stopId] else {
            return nil
        }
        return indexes.map({i in
            return self.all[i]
        })
    }
}
