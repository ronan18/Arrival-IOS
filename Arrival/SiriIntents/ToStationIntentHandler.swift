//
//  ToStationIntentHandler.swift
//  ToStationIntentHandler
//
//  Created by Ronan Furuta on 9/3/21.
//


import Foundation
import ArrivalCore
import Intents


public class ToStationIntentHandler: NSObject, TrainsToStationIntentHandling {
   
    
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
    public func resolveDestinationStation(for intent: TrainsToStationIntent) async -> IntentStationResolutionResult {
        print("resolve destionation intent")

        return IntentStationResolutionResult.success(with: intent.destinationStation!)
        
    }
    
    
    public func provideDestinationStationOptionsCollection(for intent: TrainsToStationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<IntentStation>?, Error?) -> Void) {
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
    
    
    
    public func confirm(intent: TrainsToStationIntent, completion: @escaping (TrainsToStationIntentResponse) -> Void) {
        print("confirm to trains intent")

        completion(TrainsToStationIntentResponse(code: .ready, userActivity: nil))
    }
    public func handle(intent: TrainsToStationIntent, completion: @escaping (TrainsToStationIntentResponse) -> Void) {
        guard let destination = intent.destinationStation else {
            completion(TrainsToStationIntentResponse())
            return
        }
        print("handling to trains intent")
        completion(TrainsToStationIntentResponse())
    }
}
