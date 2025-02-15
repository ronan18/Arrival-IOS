//
//  BartTime.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation

public extension Date {
    init(bartTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(abbreviation: "PST")
        dateFormatter.dateFormat = "HH:mm:ss"
       var nextDay = false
        var updatedBartString = bartTime
        
        var hourInt = Int(bartTime.prefix(2))!
        if hourInt > 23 {
            hourInt = hourInt - 24
            nextDay = true
            updatedBartString = String(updatedBartString.dropFirst(2))
            updatedBartString = "0\(hourInt)" + updatedBartString
        }
        
        
        var date = dateFormatter.date(from: updatedBartString)
        if  date == nil {
            date = Date()
           // print("ERROR DATE", bartTime)
        }
        
       
        let components = Calendar.current.dateComponents([.hour, .minute], from: date!)
        let hour = components.hour!
        let minute = components.minute!
  
       
        // get today and apply saved hour & minute
        var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date.now)
        //newComponents.timeZone = .init(abbreviation: "PST")
        newComponents.hour = hour
        newComponents.minute = minute
        
        var newDate = Calendar.current.date(from: newComponents)!
        if (nextDay) {
            newDate = newDate + 60*60*24
        }
        self = newDate
    }
}
public extension Date {
    public var bayTime: String {
        var formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "PST")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(for: self) ?? ""
    }
    public var bayTimeFull: String {
        var formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "PST")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(for: self) ?? ""
    }
}
