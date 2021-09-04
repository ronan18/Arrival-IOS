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
}