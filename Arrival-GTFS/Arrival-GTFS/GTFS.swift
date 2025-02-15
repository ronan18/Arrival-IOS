//
//  GTFS.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//


import Foundation

public class GTFS: Codable {
    public let agencies: [Agency]
    public let stops: [Stop]
    public let routes: [Route]
    public let trips: [Trip]
    public let stopTimes: [StopTime]
    public let calendar: [GTFSCalendar]?
    public let calendarDates: [CalendarDate]?
   // public let fareAttributes: [FareAttribute]? = nil
   // public let fareRules: [FareRule]?
    //public let shapes: [Shape]?
    public let frequencies: [Frequency]?
    public let transfers: [Transfer]?
    //public let pathways: [Pathway]?
    public let levels: [Level]?
    public let feedInformation: [FeedInfo]?
   // public let translations: [Translation]?
    public let attributions: [Attribution]?
    
    public init(path: String) async throws {
        let url = URL(fileURLWithPath: path)
        
        
       async let agencies: [Agency] = initializeFile(url.appendingPathComponent("agency.txt"))

        async let stops:[Stop] = initializeFile(url.appendingPathComponent("stops.txt"))
       
        async let routes: [Route] = initializeFile(url.appendingPathComponent("routes.txt"))
        
        async let trips: [Trip] = initializeFile(url.appendingPathComponent("trips.txt"))
       
        async let stopTimes:[StopTime] = initializeFile(url.appendingPathComponent("stop_times.txt"))
        
        async let calendar: [GTFSCalendar]? = initializeOptionalFile(url.appendingPathComponent("calendar.txt"))
        
        async let calendarDates: [CalendarDate]? = initializeOptionalFile(url.appendingPathComponent("calendar_dates.txt"))
       
     async let frequencies: [Frequency]? = initializeOptionalFile(url.appendingPathComponent("frequencies.txt"))
        
        async let transfers: [Transfer]? = initializeOptionalFile(url.appendingPathComponent("transfers.txt"))
        
        async let levels: [Level]? = initializeOptionalFile(url.appendingPathComponent("levels.txt"))
        
        async let feedInformation: [FeedInfo]? = initializeOptionalFile(url.appendingPathComponent("feed_info.txt"))
        
        async let attributions: [Attribution]? = initializeOptionalFile(url.appendingPathComponent("attributions.txt"))
    
        self.agencies = try await agencies
        self.stops = try await stops
        self.routes = try await routes
        self.trips = try await trips
        self.calendar =  await calendar
        self.calendarDates = await calendarDates
        self.frequencies = await frequencies
        self.transfers =  await transfers
        self.levels = await levels
        self.feedInformation = await feedInformation
        self.attributions = await attributions
        
        self.stopTimes = try await stopTimes
    
    }
   
    
}

func initializeFile<T: FromCSVLine>(_ path: URL) throws -> [T] {
    let reader = try CSVReader(path: path)
    
    return reader.map { line -> T in
        T(line: line)
    }
}

func initializeOptionalFile<T: FromCSVLine>(_ path: URL) -> [T]? {
    let reader = try? CSVReader(path: path)
    
    return reader.map { reader -> [T] in
        reader.map { line -> T in
            T(line: line)
        }
    }
}
