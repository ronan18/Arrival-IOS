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
    func getToStationSuggestions(fromStation: Station, previousRequests: [ToStationEvent], stations: StationStorage, currentToStation: Station? = nil) -> [Station] {
        let ml = MLService()
        let frequentEvents = previousRequests.filter({event in event.toStation != fromStation})
        let model = ml.train(frequentEvents)
        let cleanedStations = stations.stations.filter {$0.abbr != fromStation.abbr}
        if model.model == nil {
            return cleanedStations
        } else {
            let predictions = ml.predict(fromStation: fromStation)
            
            var frequents: [Station] = []
            frequentEvents.forEach({event in
                frequents.append(event.toStation)
            })
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
                /*
                 let filteredFrequents = frequents.filter({!predictions.contains($0)})
                 var filteredStations = cleanedStations.filter({!frequents.contains($0)})
                 filteredStations.insert(contentsOf: filteredFrequents, at: 0)
                 filteredStations.insert(contentsOf: predictions, at: 0)
                 var result = filteredStations
                 if let currentToStation = currentToStation {
                 print("ML current to station overide")
                 result = result.filter {$0 != currentToStation}
                 result.insert(currentToStation, at: 0)
                 }*/
                
                return results.filter {$0.abbr != fromStation.abbr}
            } else {
                return cleanedStations
            }
            
            
        }
        
        
    }
}
