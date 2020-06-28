//
//  Helpers.swift
//
//
//  Created by Ronan Furuta on 2/18/20.
//

import Foundation

func timeDisplay(time: String) -> String {
    return moment(time, dateFormate).format("h:mma")
}
func stationDisplay(_ station: String) -> String {
    switch station.lowercased()  {
    case "san francisco international airport" :
        return "SF Airport"
    case "Civic Center/UN Plaza".lowercased() :
        return "Civic Center"
    case "Oakland International Airport".lowercased() :
        return "Oakland Airport"
    case "Pleasant Hill/Contra Costa Centre".lowercased() :
        return "Pleasant Hill/Contra Costa"
    default:
        return station
    }
}
func tripLeaveTimeDisplay(_ trip: TripInfo) -> String {
    
    if (trip.leavesIn > 60 || trip.leavesIn < 0) {
        print("leave in more than 60")
        return timeDisplay(time: trip.originTime)
    } else {
        print("leave in less than 60")
        return String(trip.leavesIn)
    }
    
}
func tripLeaveUnitDisplay(_ trip: TripInfo) -> String {
    
    if (trip.leavesIn > 60 || trip.leavesIn < 0) {
        
        return ""
    } else {
        
        return "min"
    }
    
}
