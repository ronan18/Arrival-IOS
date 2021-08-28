//
//  Station.service.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/25/21.
//

import Foundation
import CoreLocation
import Intents

public class StationService {
    public init() {}
    public func fillOutStations(forTrip: Trip, stations: StationStorage) -> Trip {
        let legs = forTrip.legs
        var resultLegs: [TripLeg] = []
        let destination = stations.byAbbr[forTrip.destination.abbr] ?? forTrip.destination
         let origin = stations.byAbbr[forTrip.origin.abbr] ?? forTrip.origin
        legs.forEach {leg in
            debugPrint("STATION SERVICE: ", leg)
            var resultLeg = leg
            resultLeg.origin = stations.byAbbr[resultLeg.origin]?.name ?? resultLeg.origin
            resultLeg.destination = stations.byAbbr[resultLeg.destination]?.name ?? resultLeg.destination
            resultLegs.append(resultLeg)
        }
        let result = Trip(id: forTrip.id, origin: origin, destination: destination, originTime: forTrip.originTime, destinationTime: forTrip.destinationTime, tripTime: forTrip.tripTime, legs: resultLegs)
        return result
    }
    public func getClosestStations(stations: [Station], location: CLLocation) async -> ([Station]){
        print("STATION SERVICE: getting nearest station")
        let sorted = stations.sorted  {
            let station1Loc: CLLocation = CLLocation(latitude: $0.lat!, longitude: $0.long!)
            let station2Loc: CLLocation = CLLocation(latitude: $1.lat!, longitude: $1.long!)
            let distance1Miles = location.distance(from: station1Loc)
            let distance2Miles = location.distance(from: station2Loc)
            return distance1Miles < distance2Miles
        }
        return sorted
    }
   
}
