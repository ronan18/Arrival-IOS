//
//  CalendarDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation
public struct GTFSCalendarDB: Codable, Hashable, Equatable {
   
    
    public let all: [GTFSCalendar]
    private let byServiceIDIndex: [String: Int]
    init() {
        self.all = []
        self.byServiceIDIndex = [:]
    }
    public init(from calendars: [GTFSCalendar]) {
        self.all = calendars
        var byID: [String: Int] = [:]
        for i in 0..<all.count {
           let transfer = all[i]
            
            byID[transfer.serviceId] = i
        }
        self.byServiceIDIndex = byID
    }
    public func byServiceID(_ serviceId: String) -> GTFSCalendar? {
        guard let index = self.byServiceIDIndex[serviceId] else {
            return nil
        }
        return all[index]
    }
}
