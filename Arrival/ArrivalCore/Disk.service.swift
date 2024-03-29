//
//  Disk.service.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/24/21.
//

import Foundation
import Disk
public class DiskService {
   // private var dataLocation = Directory.sharedContainer(appGroupName: "group.com.ronanfuruta.arrival")
    public init() {
        
    }
    public func getStations() -> StationStorage? {
        do {
            let stations = try Disk.retrieve("stations.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"), as: StationStorage.self)
            //print(stations)
            if (stations.stations.isEmpty) {
                return nil
            }
            return stations
        } catch {
            return nil
        }
    }
    public func saveStations(_ stationData: StationStorage) {
        do {
            try Disk.save(stationData, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"), as: "stations.json")
           // print("saved stations")
        } catch {
           // print("error saving stations")
        }
    }
    public func storeTipEvent(_ event: TripEvent) {
       
        do {
           try Disk.append(event, to: "tripEvents.json", in: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"))
        } catch {
            print("error saving tripe event")
        }
    }
    public func storeDirectionFilterEvent(_ event: DirectionFilterEvent) {
        var currentEvents = self.getDirectionFilterEvents()
        currentEvents = currentEvents.filter {a in
            if (a.sessionID == a.sessionID) {
                
             //   print("\(a.fromStation.abbr != event.fromStation.abbr ? "keeping" : "removing") \(a.fromStation) \(a.direction) \(a.sessionID) directions")
                return a.fromStation.abbr != event.fromStation.abbr
            } else {
                return true
            }
        }
        currentEvents.append(event)
        do {
            try Disk.save(currentEvents, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"), as: "directionFilterEvents.json")
          // try Disk.append(event, to: "directionFilterEvents.json", in: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"))
        } catch {
            print("error saving tripe event")
        }
    }
    public func getTripEvents() -> [TripEvent] {
        var events: [TripEvent] = []
        do {
          events  =  try Disk.retrieve("tripEvents.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"), as: [TripEvent].self)
        } catch {
            
        }
        return events
    }
    public func getDirectionFilterEvents() -> [DirectionFilterEvent] {
        var events: [DirectionFilterEvent] = []
        do {
          events  =  try Disk.retrieve("directionFilterEvents.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"), as: [DirectionFilterEvent].self)
        } catch {
            
        }
        return events
    }
    public func resetDirectionFilterEvents() {
        do {
            try Disk.remove("directionFilterEvents.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"))
        } catch {
        
        }
    }
    public func resetTripEvents() {
        do {
            try Disk.remove("tripEvents.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival"))
        } catch {
            
        }
    }
}
