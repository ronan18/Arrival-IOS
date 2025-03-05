//
//  StoptimesDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation
public struct StopTimesDB: Codable, Hashable, Equatable {
  
    public var all: [StopTime]
    
   
    
    private let stopTimeByIdIndex: [String: Int]
    private let byStopIdIndex: [String: [Int]]
    private let byTripIDIndex: [String: [Int]]
    private let byDepartureHourIndex: [String: [Int]]
    init() {
        self.all = []
        self.stopTimeByIdIndex = [:]
        self.byStopIdIndex = [:]
        self.byTripIDIndex = [:]
        self.byDepartureHourIndex = [:]
    }
    public init(from stopTimes: [StopTime]) {
        let stopTimes = stopTimes.sorted(by: {a,b in
            a.departureTime < b.departureTime
        })
        self.all = stopTimes
        var byStopTimeID: [String: Int] = [:]
        var byStopID: [String: [Int]] = [:]
        var byTripID: [String: [Int]] = [:]
        var byDepartureHourIndex: [String: [Int]] = [:]
        for i in 0..<stopTimes.count {
            let stopTime = stopTimes[i]
            byStopTimeID[stopTime.id] = i
            var current =  byStopID[stopTime.stopId] ?? []
            current.append(i)
            byStopID[stopTime.stopId] = current
            var currentByTripID: [Int] = byTripID[stopTime.tripId] ?? []
            currentByTripID.append(i)
            byTripID[stopTime.tripId] = currentByTripID
            
            var currentDepartureHourIndex = byDepartureHourIndex[String(stopTime.departureTime.prefix(2))] ?? []
            
            if currentDepartureHourIndex.count == 0 {
                currentDepartureHourIndex = [i,i]
            } else if currentDepartureHourIndex.count == 2 {
                currentDepartureHourIndex = [currentDepartureHourIndex.first!, i]
            }
            byDepartureHourIndex[String(stopTime.departureTime.prefix(2))] = currentDepartureHourIndex
            
        }
        
       
       
        
        byTripID.keys.forEach {key in
            byTripID[key] = byTripID[key]?.sorted(by: { a, b in
                stopTimes[a].stopSequence < stopTimes[b].stopSequence
            })
        }
      
        
        self.stopTimeByIdIndex = byStopTimeID
        self.byStopIdIndex = byStopID
        self.byTripIDIndex = byTripID
       
        self.byDepartureHourIndex = byDepartureHourIndex
  
    }
    public func byDepartureHour(_ hour: String) -> [StopTime] {
       
        let indexes = self.byDepartureHourIndex[hour] ?? []
        guard let first = indexes.first else {
            return []
        }
        let last = indexes.last ?? self.all.count - 1
        let allIndexes = self.all[first...last]
        return Array(allIndexes)
    }
    public func byDepartureHour(from: String, to: String) -> [StopTime] {
       
     //  print("by departure hour", from, to)
        guard let first = self.byDepartureHourIndex[from]?.first else {
            return []
        }
        let last = self.byDepartureHourIndex[to]?.last ?? self.all.count - 1
        let allIndexes = self.all[first...last]
        return Array(allIndexes)
    }
    public func byStopTimeID(_ stopTimeId: String) -> StopTime? {
        guard let index = self.stopTimeByIdIndex[stopTimeId] else {
            return nil
        }
        return self.all[index]
    }
    
    ///Shows all stop times for a particular Station
    ///Sorted by time
    public func byStopID(_ stopId: String) -> [StopTime]? {
        return self.byStopIdIndex[stopId].map{stopTimeIndexes in
            return stopTimeIndexes.map({i in
                return all[i]
            })
        }
    }
    ///Shows all stops timesfor a partidular trip
    public func byTripID(_ tripId: String) -> [StopTime]? {
        return self.byTripIDIndex[tripId].map{stopTimeIndexes in
            return stopTimeIndexes.map({i in
                return all[i]
            })
        }
    }
    
    mutating
    public func update(_ stopTime: StopTime) {
        guard let index = self.stopTimeByIdIndex[stopTime.id] else {
            return
        }
        self.all[index] = stopTime
    }
    
    mutating public func insert(_ stopTime: StopTime) {
        guard !self.all.contains(stopTime) else {
            return
        }
        var all = self.all
        all.append(stopTime)
        self = .init(from: all)
    }
    mutating public func insert(_ stopTimes: [StopTime]) {
        
        var all = self.all
        all.append(contentsOf: stopTimes.filter({time in
            return !self.all.contains(time)
        }))
        self = .init(from: all)
    }
}
