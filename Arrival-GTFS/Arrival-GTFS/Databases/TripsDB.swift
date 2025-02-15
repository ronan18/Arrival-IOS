//
//  TripsDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation
public struct TripsDB: Codable, Hashable, Equatable {
  
    public var all: [Trip]
    
    private var byTripIDIndex: [String: Int]
    private var byStopIDIndex: [String: [Int]]
    private var byRouteIDIndex: [String: [Int]]
    init() {
        self.all = []
        self.byTripIDIndex = [:]
        self.byStopIDIndex = [:]
        self.byRouteIDIndex = [:]
    }
    
    public init(from trips: [Trip], stopTimes: [StopTime]) {
        self.all = trips
        var inProgress: [String: Int] = [:]
        var byRouteIDIndex: [String: [Int]] = [:]
        for i in 0..<trips.count {
            let trip = trips[i]
            inProgress[trip.tripId] = i
            if let currentRoute = byRouteIDIndex[trip.routeId] {
                var currentRouteI = currentRoute
                currentRouteI.append(i)
                byRouteIDIndex[trip.routeId] =  currentRouteI
            } else {
                byRouteIDIndex[trip.routeId] = [i]
            }
        }
        self.byRouteIDIndex = byRouteIDIndex
        /*
         trips.forEach({trip in
         inProgress[trip.tripId] = trip
         })*/
        self.byTripIDIndex = inProgress
        
        
        var byStopID: [String: [Int]] = [:]
        stopTimes.forEach({stopTime in
            if let tripForStopTime = inProgress[stopTime.tripId] {
                var currentIndexed = (byStopID[stopTime.stopId] ?? [])
                currentIndexed.append(tripForStopTime)
                byStopID[stopTime.stopId] = currentIndexed
            }
            
        })
        self.byStopIDIndex = byStopID
        
      
        print("trips DB built")
    }
    
    public func byTripID(_ tripId: String) -> Trip? {
        guard let index = self.byTripIDIndex[tripId] else {
            return nil
        }
        return self.all[index]
    }
    ///Shows all trips that pass through a particular stop
    public func byStopID(_ stopId: String) -> [Trip]? {
        return self.byStopIDIndex[stopId].map({tripIndexs in
            return tripIndexs.map({index in
                return all[index]
            })
        })
    }
    public func byRouteID(_ routeId: String) -> [Trip]? {
        return self.byRouteIDIndex[routeId].map({trips in
            return trips.map({i in
                return all[i]
            })
        })
    }
    mutating public func insert(_ trip: Trip, stopTimes: [StopTime]) {
        guard !self.all.contains(trip) else {
            return
        }
        self.all.append(trip)
        var inProgress: [String: Int] =  self.byTripIDIndex
        var byRouteIDIndex: [String: [Int]] = [:]
       var  i = self.all.count - 1
            let trip = self.all[i]
            inProgress[trip.tripId] = i
            if let currentRoute = byRouteIDIndex[trip.routeId] {
                var currentRouteI = currentRoute
                currentRouteI.append(i)
                byRouteIDIndex[trip.routeId] =  currentRouteI
            } else {
                byRouteIDIndex[trip.routeId] = [i]
            }
        
        self.byRouteIDIndex = byRouteIDIndex
        /*
         trips.forEach({trip in
         inProgress[trip.tripId] = trip
         })*/
        self.byTripIDIndex = inProgress
        
        
        var byStopID: [String: [Int]] = self.byStopIDIndex
        stopTimes.forEach({stopTime in
            guard stopTime.tripId == trip.tripId else {
                return
            }
            if let tripForStopTime = inProgress[stopTime.tripId] {
                var currentIndexed = (byStopID[stopTime.stopId] ?? [])
                currentIndexed.append(tripForStopTime)
                byStopID[stopTime.stopId] = currentIndexed
            }
            
        })
        self.byStopIDIndex = byStopID
        

        print("TRIPS DB: inserted \(trip.tripId)")
    }
    
}
