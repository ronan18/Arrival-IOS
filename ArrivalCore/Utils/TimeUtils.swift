//
//  TimeUtils.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

func convertBartDate(time: String, date: String) -> Date? {
     let dateString = time + " " + date
  //  print("convert date", dateString)
   
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.timeStyle = .medium
    dateFormatter.dateFormat = "HH:mm a MM/dd/yyyy"
    let date = dateFormatter.date(from: dateString)
   // print("date",dateFormatter.string(from: date!))
    return date
}
