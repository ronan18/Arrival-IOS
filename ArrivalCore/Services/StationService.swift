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
    func fillOutStations(forTrip: Trip, stations: StationStorage) -> Trip {
        let legs = forTrip.legs
        var resultLegs: [TripLeg] = []
        legs.forEach {leg in
            debugPrint("STATION SERVICE: ", leg)
            var resultLeg = leg
            resultLeg.origin = stations.byAbbr[resultLeg.origin]?.name ?? resultLeg.origin
            resultLeg.destination = stations.byAbbr[resultLeg.destination]?.name ?? resultLeg.destination
            resultLegs.append(resultLeg)
        }
        var result = Trip(id: forTrip.id, origin: forTrip.origin, destination: forTrip.destination, originTime: forTrip.originTime, destinationTime: forTrip.destinationTime, tripTime: forTrip.tripTime, legs: resultLegs)
        return result
    }
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
    func getToStationSuggestions(fromStation: Station, previousRequests: [ToStationEvent], stations: StationStorage, currentToStation: Station? = nil) -> [Station] {
        let ml = MLService()
        let frequentEvents = previousRequests.filter({event in event.toStation != fromStation})
        let model = ml.train(frequentEvents)
      
        var frequents: [Station] = []
                   frequentEvents.forEach({event in
                       frequents.append(event.toStation)
                   })
        if model.model == nil {
            var results = stations.stations
            //    print("ml, pre frequents count", results.count)
            results = results.filter({
                let remove = !frequents.contains($0)
                
                if (!remove) {
                    //          print("ml filter frequents", $0.abbr, remove)
                }
                return remove
                
            })
            //     print("ml, post frequents count", results.count)
            
            frequents.forEach {prediction in
                //      print("ml inserting frequent", prediction.abbr)
                if (!results.contains(prediction)) {
                    results.insert(prediction, at: 0)
                }
            }
            print("ML added frequents")
            if let currentToStation = currentToStation {
                print("ML current to station overide")
                results = results.filter {$0 != currentToStation}
                results.insert(currentToStation, at: 0)
            }
            return results.filter {$0.abbr != fromStation.abbr}
        } else {
            let predictions = ml.predict(fromStation: fromStation)
            
           
            if let predictions = predictions {
                var results = stations.stations
                //    print("ml, pre frequents count", results.count)
                results = results.filter({
                    let remove = !frequents.contains($0)
                    
                    if (!remove) {
                        //          print("ml filter frequents", $0.abbr, remove)
                    }
                    return remove
                    
                })
                //     print("ml, post frequents count", results.count)
                
                frequents.forEach {prediction in
                    //      print("ml inserting frequent", prediction.abbr)
                    if (!results.contains(prediction)) {
                        results.insert(prediction, at: 0)
                    }
                }
                //  print("ml, pre predictions count", results.count)
                results = results.filter({
                    let remove = !predictions.contains($0)
                    
                    if (!remove) {
                        //  print("ml filter predictions", $0.abbr, remove)
                    }
                    return remove
                    
                })
                //  print("ml, post predictions count", results.count)
                predictions.forEach {prediction in
                    if (!results.contains(prediction)) {
                        results.insert(prediction, at: 0)
                    }
                }
                
                // print("ml, pre current to station count", results.count)
                if let currentToStation = currentToStation {
                    print("ML current to station overide")
                    results = results.filter {$0 != currentToStation}
                    results.insert(currentToStation, at: 0)
                }
                //   print("ml, final count", results.count)
                return results.filter {$0.abbr != fromStation.abbr}
            } else {
                var results = stations.stations
                //    print("ml, pre frequents count", results.count)
                results = results.filter({
                    let remove = !frequents.contains($0)
                    
                    if (!remove) {
                        //          print("ml filter frequents", $0.abbr, remove)
                    }
                    return remove
                    
                })
                //     print("ml, post frequents count", results.count)
                
                frequents.forEach {prediction in
                    //      print("ml inserting frequent", prediction.abbr)
                    if (!results.contains(prediction)) {
                        results.insert(prediction, at: 0)
                    }
                }
                if let currentToStation = currentToStation {
                    print("ML current to station overide")
                    results = results.filter {$0 != currentToStation}
                    results.insert(currentToStation, at: 0)
                }
                return results.filter {$0.abbr != fromStation.abbr}
            }
            
            
        }
        
        
    }
}
