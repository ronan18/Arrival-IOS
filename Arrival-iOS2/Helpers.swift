//
//  Helpers.swift
//
//
//  Created by Ronan Furuta on 2/18/20.
//

import Foundation

func timeDisplay(time: String) -> String {
    return moment(time, dateFormate).format("h:mm a")
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
