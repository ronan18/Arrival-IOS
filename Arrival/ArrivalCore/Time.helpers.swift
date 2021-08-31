//
//  Time.helpers.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/23/21.
//

import Foundation
public func convertBartDate(time: String, date: String) -> Date? {
    let dateString = time + " " + date
    //  print("convert date", dateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.timeStyle = .medium
    dateFormatter.dateFormat = "hh:mm a MM/dd/yyyy"
    let date = dateFormatter.date(from: dateString)
    // print("date",dateFormatter.string(from: date!))
    return date
}
public func timeIntervalUntil(_ date: Date) -> TimeInterval {
    return date.timeIntervalSince(Date())
}
public func getTimeDifference(from: Date, to: Date) -> TimeInterval {
    return to.timeIntervalSince(from)
}
public func convertDateToISO(_ time: Date) -> String {
   let formatter = ISO8601DateFormatter()
    return formatter.string(from: time)
}
