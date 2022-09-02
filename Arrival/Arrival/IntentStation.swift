//
//  IntentStation.swift
//  Arrival
//
//  Created by Ronan Furuta on 6/7/22.
//

import Foundation
import AppIntents
import ArrivalCore
func getStations() async -> StationStorage? {
   let api = ArrivalAPI()
   let diskService = DiskService()
   var stations: StationStorage? = nil
   stations = diskService.getStations()
   guard stations == nil else {
       return stations
   }
   do {
       print("APP INTENT: returning stations from storage for app intent")
       stations = try await api.stations()
       diskService.saveStations(stations!)
       return stations
   } catch {
       print("APP INTENT: ERROR returning stations from storage for app intent")
       return nil
   }
   
}
struct IntentStation: AppEntity {
   
    
    static _const let intentTypeClassName = "IntentStation"
    static var typeDisplayName: LocalizedStringResource = "Station"
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Station"
    
   
    static var defaultQuery = StationQuery()

    var id: String // if your identifier is not a String, conform the entity to EntityIdentifierConvertible.
    var displayRepresentation: DisplayRepresentation
}

struct StationQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [IntentStation] {
        print("APP INTENT: searching for results for station by id")
        let stations = await getStations()?.stations ?? []
        let potentials = stations.filter({station in
            return identifiers.contains(station.id)
        })
        let stationIntents: [IntentStation] = potentials.map { station in
            return IntentStation(id: station.abbr, displayRepresentation: DisplayRepresentation(stringLiteral: station.name))
        }
        
        return stationIntents
    }
    func suggestedEntities() async throws -> [IntentStation] {
        print("APP INTENT: searching for results for station")
        let stations = await getStations()?.stations ?? []
        var stationIntents: [IntentStation] = stations.map { station in
            return IntentStation(id: station.abbr, displayRepresentation: DisplayRepresentation(stringLiteral: station.name))
        }
        stationIntents.insert(IntentStation(id: "CURRENTLOC", displayRepresentation: "Current Location"), at: 0)
        return stationIntents
    }
   
    
}

/* struct IntentStationQuery: EntityQuery {
 func entities(for identifiers: [IntentStation.ID]) async throws -> [IntentStation] {
     // TODO: return IntentStation entities with the specified identifiers here.
     print("APP INTENT: searching for results for station by id")
     let stations = await getStations()?.stations ?? []
     let potentials = stations.filter({station in
         return identifiers.contains(station.id)
     })
     let stationIntents: [IntentStation] = potentials.map { station in
         return IntentStation(id: station.abbr, displayRepresentation: DisplayRepresentation(stringLiteral: station.name))
     }
     
     return stationIntents
 }
 func suggestedResults() async throws -> [IntentStation] {
     print("APP INTENT: searching for results for station")
     let stations = await getStations()?.stations ?? []
     var stationIntents: [IntentStation] = stations.map { station in
         return IntentStation(id: station.abbr, displayRepresentation: DisplayRepresentation(stringLiteral: station.name))
     }
     stationIntents.insert(IntentStation(id: "CURRENTLOC", displayRepresentation: "Current Location"), at: 0)
     return stationIntents
 }
}
 */
