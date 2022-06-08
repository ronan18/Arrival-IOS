//
//  Time.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/23/21.
//

import Foundation

public enum TripType: String {
    case leave = "leave"
    case arrive = "arrive"
    case now = "now"
}
public struct TripTime {
    public var type: TripType
    public var time: Date
    public var iso: String
    public init (type: TripType, time: Date? = nil) {
        self.type = type
        if (type == .now) {
            self.time = Date()
        } else {
            self.time = time ?? Date()
        }
        self.iso = convertDateToISO(self.time)
    }
    
}
public enum TimeDisplayType {
    case timeTill
    case etd
}
