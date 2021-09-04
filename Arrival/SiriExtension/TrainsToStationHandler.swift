//
//  TrainsToStationHandler.swift
//  TrainsToStationHandler
//
//  Created by Ronan Furuta on 9/4/21.
//

import Foundation

import Intents
import ArrivalCore

class ToStationIntentHandler: NSObject, TrainsToStationIntentHandling {
    
    let api = ArrivalAPI()
    let diskService = DiskService()
    var stations: StationStorage? = nil
    func getStations() async -> StationStorage? {
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
    func handle(intent: TrainsToStationIntent) async -> TrainsToStationIntentResponse {
        return TrainsToStationIntentResponse()
    }
    
    
    func resolveDestinationStation(for intent: TrainsToStationIntent) async -> IntentStationResolutionResult {
        print("resolve destionation intent")
        
        return IntentStationResolutionResult.success(with: intent.destinationStation!)
    }
    
    
    func resolveDepartureStation(for intent: TrainsToStationIntent) async -> IntentStationResolutionResult {
        print("resolve departure intent")
        
        return IntentStationResolutionResult.success(with: intent.departureStation!)
    }
    
    func provideDestinationStationOptionsCollection(for intent: TrainsToStationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<IntentStation>?, Error?) -> Void) {
        print("Destination thhings running")
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
            let stationIntents: [IntentStation] = potentials.map { station in
                return IntentStation(identifier: station.abbr, display: station.name)
            }
            let result = INObjectCollection(items: stationIntents)
            completion(result , nil)
        }
    }
    
    func provideDepartureStationOptionsCollection(for intent: TrainsToStationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<IntentStation>?, Error?) -> Void) {
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
