//
//  GTFSDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation

public class GTFSDB: Codable {
    static let shared: GTFSDB = .init()
    
    var stationsDB: StationsDB = .init()
    var transfersDB: TransfersDB = .init()
    var calendarsDB: GTFSCalendarDB = .init()
    var stopTimesDB: StopTimesDB = .init()
    var tripsDB: TripsDB = .init()
    var routesDB: RoutesDB = .init()
    
    func importData(_ gtfsDB: GTFSDB) {
        self.stationsDB = gtfsDB.stationsDB
        self.transfersDB = gtfsDB.transfersDB
        self.calendarsDB = gtfsDB.calendarsDB
        self.stopTimesDB = gtfsDB.stopTimesDB
        self.tripsDB = gtfsDB.tripsDB
        self.routesDB = gtfsDB.routesDB
    }
    
    func ingest(gtfs: GTFS) async throws {
        async let stationsDB = StationsDB(from: gtfs.stops)
        
        guard let transfers = gtfs.transfers else {
            throw GTFSDBError.insufficentData
        }
        guard let calendars = gtfs.calendar else {
            throw GTFSDBError.insufficentData
        }
        async let transfersDB = TransfersDB(from: transfers)
        async let calendarsDB = GTFSCalendarDB(from: calendars)
        async let stoptimesDB = StopTimesDB(from: gtfs.stopTimes)
        async let tripsDB = TripsDB(from: gtfs.trips, stopTimes: gtfs.stopTimes)
        
        self.stationsDB = await stationsDB
        self.transfersDB = await transfersDB
        self.calendarsDB = await calendarsDB
        self.stopTimesDB = await stoptimesDB
        self.tripsDB = await tripsDB
        
        async let routesDB = RoutesDB(from: gtfs.routes, trips: self.tripsDB, stations: self.stationsDB)
        self.routesDB = await routesDB
        
    }
   
}

public enum GTFSDBError: Error {
    case insufficentData
}
