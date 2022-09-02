//
//  TrainsToStation.swift
//  Arrival
//
//  Created by Ronan Furuta on 6/7/22.
//

import Foundation
import AppIntents

struct TrainsToStation: AppIntent {
    static _const let intentClassName = "TrainsToStationIntent"
    
    static var title: LocalizedStringResource = "Trains to a BART station (new)"
    static var description = IntentDescription("open Arrival and see trains heading to a specific station. (new)")

    @Parameter(title: "Destination Station")
    var destinationStation: IntentStation

    @Parameter(title: "Departure Station")
    var departureStation: IntentStation?

    static var parameterSummary: some ParameterSummary {
        Summary("Get BART trains from \(\.$departureStation) to \(\.$destinationStation)")
    }
    func perform() async throws -> some IntentResult {
        print("APP INTENT: trains to station intent running")
        return .result(value: true)
    }
}

