//
//  AI.service.swift
//  AI.service
//
//  Created by Ronan Furuta on 8/31/21.
//

import Foundation
import TabularData
import CoreML
import Intents
//#if true
import CreateML

public class AIService {
    let diskService = DiskService()
    public init () {
        print("production ai being used")
    }
    public func logTripEvent(_ event: TripEvent) {
        self.diskService.storeTipEvent(event)
        let intent = TrainsToStationIntent()
        intent.departureStation = IntentStation(identifier: event.fromStation.id, display: event.fromStation.name)
        intent.destinationStation = IntentStation(identifier: event.toStation.id, display: event.toStation.name)
        
        INInteraction(intent: intent, response: nil).donate { (error) in
            if let error = error {
                print("\n Error: \(error.localizedDescription))")
            } else {
                print("\n Donated CreateExpenseIntent")
            }
        }
    }
    public func train() async {
        print("running training")
        let events  = self.diskService.getTripEvents()
        // debugPrint(events)
        var dataTable: DataFrame = DataFrame()
        dataTable.append(column: Column<String>(name: "weekOfYear", capacity: events.count))
        dataTable.append(column: Column<String>(name: "dayOfWeek", capacity: events.count))
        dataTable.append(column: Column<String>(name: "time", capacity: events.count))
        dataTable.append(column: Column<String>(name: "fromStation", capacity: events.count))
        dataTable.append(column: Column<String>(name: "toStation", capacity: events.count))
        // dataTable.append(valuesByColumn: ["time": "now", "fromStation": "test from", "toStation": "toStationTest"])
        // dataTable.append(row: ["test", "test", "test"])
        // dataTable.append(row: ["test2", "test2", "test2"])
        events.forEach {event in
            print(event)
            let time  = event.date.formatted(date: .omitted, time: .complete)
            
            
            dataTable.append(valuesByColumn: ["time": time, "fromStation": event.fromStation.abbr, "toStation": event.toStation.abbr, "weekOfYear": "", "dayOfWeek": ""])
        }
        debugPrint(dataTable)
        
        // debugPrint(dataTable)
        do {
            let classifier = try MLLogisticRegressionClassifier(trainingData: dataTable, targetColumn: "toStation")
          try  classifier.write(toFile: "tripStationAI.mlmodel", metadata: MLModelMetadata(author: "Ronan Furuta Arrival", shortDescription: "tripStation AI", license: nil, version: "1", additional: nil))
            let results = try classifier.predictions(from: dataTable)
            debugPrint(results)
            
        }catch {
            print(error)
        }
        
    }
    public func predictDestinationStation(_ currentStation: Station) {
        let model = MLLogisticRegressionClassifier.r
        
    }
}
/*#else
 public class AIService {
 public init() {
 print("using debug AI service")
 }
 public func train() {
 print("train using debug AI service")
 }
 }
 #endif
 
 */
