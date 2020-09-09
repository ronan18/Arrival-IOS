//
//  TimeUtils.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

struct TimeDisplay {
    let time: String
    let a: String
}

func convertBartDate(time: String, date: String) -> Date? {
    let dateString = time + " " + date
      print("convert date", dateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.timeStyle = .medium
    dateFormatter.dateFormat = "hh:mm a MM/dd/yyyy"
    let date = dateFormatter.date(from: dateString)
     print("date",dateFormatter.string(from: date!))
    return date
}
func displayTimeInterval(_ time: TimeInterval) -> TimeDisplay {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute]
    formatter.unitsStyle = .abbreviated
    formatter.maximumUnitCount = 1
    var time = formatter.string(from: time)!
   time = String(time.dropLast())
    return TimeDisplay(time: time, a: "min")
}
func displayMinutes(_ date: Date) -> Int {
    // print(date)
    let timeFromNow = date.timeIntervalSince(Date())
   
    // print(timeFromNow)
    return Int(round(timeFromNow / 60))
}
func displayMinutesString(_ date: Date) -> TimeDisplay{
    let timeFromNow = date.timeIntervalSince(Date())
    if (timeFromNow / 60) > 40 {
        print("TIME:", timeFromNow, displayTime(date))
        return displayTime(date)
    } else if (timeFromNow / 60) < 1 {
        print("TIME:", "now")
        return TimeDisplay(time: "now", a: "")
    } else {
        print("TIME:", timeFromNow)
        return TimeDisplay(time: String(Int(round(timeFromNow / 60))), a: "min")
    }
}
func timeIntervalUntil(_ date: Date) -> TimeInterval {
    return date.timeIntervalSince(Date())
}
func getTimeDifference(from: Date, to: Date) -> TimeInterval {
    return to.timeIntervalSince(from)
}
func displayTime(_ date: Date) -> TimeDisplay {
    // print(date)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .none
    let time: String = dateFormatter.string(from: date)
    
    return TimeDisplay(time: String(time.dropLast(3)) , a: String(time.suffix(2).lowercased()))
    
}

func convertDateToISO(_ time: Date) -> String {
   let formatter = ISO8601DateFormatter()
    return formatter.string(from: time)
}
