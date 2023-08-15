//
//  DiskManager.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import ArrivalGTFS
import Disk
public class ArrivalDiskManager {
    private let directory: Disk.Directory = .sharedContainer(appGroupName: "group.com.ronanfuruta.arrival")
    public func stationsDB() -> StationsDB {
        
        guard let db = try? Disk.retrieve("stationsdb", from: directory, as: StationsDB.self) else {
            return StationsDB(from: [])
        }
        return db
    }
    public func updateStationsDB(_ db: StationsDB) {
        do {
            try Disk.save(db, to: directory, as: "stationsdb")
        } catch {
            print("error saving stations db", error)
        }
    }
    public func routesDB() -> RoutesDB? {
        
        guard let db = try? Disk.retrieve("routesDB", from: directory, as: RoutesDB.self) else {
            return nil
        }
        return db
    }
    public func updateRoutesDB(_ db: RoutesDB) {
        do {
            try Disk.save(db, to: directory, as: "routesDB")
        } catch {
            print("error saving routes db", error)
        }
    }
    
}
