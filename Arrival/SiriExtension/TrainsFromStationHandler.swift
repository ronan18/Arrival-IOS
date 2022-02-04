//
//  TrainsFromStationHandler.swift
//  SiriExtension
//
//  Created by Ronan Furuta on 12/28/21.
//

import Foundation

import Intents
import ArrivalCore

class FromStationHandler: NSObject, TrainsFromStationIntentHandling {
    let api = ArrivalAPI()
    let diskService = DiskService()
    var stations: StationStorage? = nil
    func getStations() async -> StationStorage? {
        print("get station")
        guard self.stations == nil else {
            return self.stations!
        }
        self.stations = self.diskService.getStations()
        guard self.stations == nil else {
            return self.stations!
        }
        do {
            self.stations = try await self.api.stations()
            return self.stations
        } catch {
            return nil
        }
        
    }
   
    
    func handle(intent: TrainsFromStationIntent) async -> TrainsFromStationIntentResponse {
        return TrainsFromStationIntentResponse()
    }
    
   
    
    func resolveFromStation(for intent: TrainsFromStationIntent) async -> IntentStationResolutionResult {
        print("resolve departure intent")
        
        return IntentStationResolutionResult.success(with: intent.fromStation!)
    }
    
    func provideFromStationOptionsCollection(for intent: TrainsFromStationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<IntentStation>?, Error?) -> Void) {
        print("Departure thhings running")
        Task {
            let stationsReq = await getStations()
            guard let stations = stationsReq?.stations else {
                completion(nil, nil)
                print("ERROR no stations exist")
                return
            }
            let potentials = stations.filter {station in
                guard let searchTerm = searchTerm else {
                    return true
                }
                
                return station.name.contains(searchTerm)
            }
            var stationIntents: [IntentStation] = potentials.map { station in
                return IntentStation(identifier: station.abbr, display: station.name)
            }
            stationIntents.insert(IntentStation(identifier: "CURRENTLOC", display: "Current Location"), at: 0)
            let result = INObjectCollection(items: stationIntents)
            completion(result , nil)
        }
    }
    
    
    
    
}
