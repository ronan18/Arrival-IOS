//
//  TrainsFromStation.swift
//  Arrival
//
//  Created by Ronan Furuta on 6/7/22.
//

import Foundation
import AppIntents
import ArrivalUI
import SwiftUI
struct TrainsFromStation: AppIntent {
    static _const let intentClassName = "TrainsFromStationIntent"
    
    static var title: LocalizedStringResource = "Trains from a BART station (new)"
    static var description = IntentDescription("View trains in realtime from a BART station (new)")
static var openAppWhenRun: Bool = true
    @Parameter(title: "Departure Station")
    var fromStation: IntentStation?

    static var parameterSummary: some ParameterSummary {
        Summary("Get BART trains from \(\.$fromStation)")
    }
    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        // TODO: Place your refactored intent handler code here.
        // .finished(dialog: "Finished with stuff!")
        print("APP INTENT: TrainsFromStationIntent running", self.fromStation)
      //  return .result(opensIntent: <#T##AppIntent#>)
        
    
            let fromStation = self.fromStation ?? IntentStation(id: "CURRENTLOC", displayRepresentation: "Current Location")
        let fromStationText = fromStation.displayRepresentation.title
       
        
        
        return .result(dialog: "Showing Trains from \(fromStationText)", view: Text("test"))
    }
}

struct TrainsFromStationShortcut: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut]{
        AppShortcut(intent: TrainsFromStation(), phrases: ["Get BART trains with \(.applicationName)"])
    }
}
