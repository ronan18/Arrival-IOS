//
//  StationService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import CoreLocation

class StationService {
    func getClosestStations(stations: [Station], location: CLLocation, handleComplete: @escaping (([Station])->())) {
        print("STATION SERVICE: getting nearest station")
        let sorted = stations.sorted  {
            let station1Loc: CLLocation = CLLocation(latitude: $0.lat!, longitude: $0.long!)
            let station2Loc: CLLocation = CLLocation(latitude: $1.lat!, longitude: $1.long!)
            let distance1Miles = location.distance(from: station1Loc)
            let distance2Miles = location.distance(from: station2Loc)
            return distance1Miles < distance2Miles
        }
       handleComplete(sorted)
    }
    func getToStationSuggestions(fromStation: Station, previousRequests: [ToStationEvent], stations: StationStorage) -> [Station] {
        return stations.stations.filter {$0.abbr != fromStation.abbr}
        
    }
}
