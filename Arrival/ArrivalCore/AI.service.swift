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
    var model: MLLogisticRegressionClassifier? = nil
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
        dataTable.append(column: Column<Int>(name: "month", capacity: events.count))
        dataTable.append(column: Column<Int>(name: "dayOfWeek", capacity: events.count))
        dataTable.append(column: Column<String>(name: "time", capacity: events.count))
        dataTable.append(column: Column<String>(name: "fromStation", capacity: events.count))
        dataTable.append(column: Column<String>(name: "toStation", capacity: events.count))
        // dataTable.append(valuesByColumn: ["time": "now", "fromStation": "test from", "toStation": "toStationTest"])
        // dataTable.append(row: ["test", "test", "test"])
        // dataTable.append(row: ["test2", "test2", "test2"])
        events.forEach {event in
            print(event)
            let time  = event.date.formatted(date: .omitted, time: .complete)
            let components = dateComponents(Date())
            
            dataTable.append(valuesByColumn: ["time": time, "fromStation": event.fromStation.abbr, "toStation": event.toStation.abbr, "dayOfWeek": components.weekday, "month": components.month])
        }
        debugPrint(dataTable)
        
        // debugPrint(dataTable)
        do {
            let classifier = try MLLogisticRegressionClassifier(trainingData: dataTable, targetColumn: "toStation")
          // try classifier.write(toFile: "tripStationAI.mlmodel", metadata: MLModelMetadata(author: "Ronan Furuta Arrival", shortDescription: "tripStation AI", license: nil, version: "1", additional: nil))
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let assetPath = documentsDirectory.appendingPathComponent("tripStationAI.mlmodel")
                print(assetPath, "asset  ML path")
                try classifier.write(to: assetPath, metadata: MLModelMetadata(author: "Ronan Furuta Arrival", shortDescription: "tripStation AI", license: nil, version: "1", additional: nil))
            }
           
           
            let results = try classifier.predictions(from: dataTable)
            self.model = classifier
            debugPrint(results)
            self.predictDestinationStation(Station(id: "test", name: "ROCK", abbr: "ROCK", lat: 0, long: 0))
            
        }catch {
            print(error, "saving AI model")
        }
        
    }
    public func loadModel() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let assetPath = documentsDirectory.appendingPathComponent("tripStationAI.mlmodel")
        print(assetPath)
       
        do {
           // Model
         
          var model: MLModel = try MLModel(contentsOf: assetPath)
            print("got moddel")
           // model.predictions
        } catch {
            print(error, "AI")
        }
       
        }
    }
    public func predictDestinationStation(_ currentStation: Station) {
        guard let classifier = model else {
            self.loadModel()
            return
        }
        do {
            var dataTable: DataFrame = DataFrame()
            dataTable.append(column: Column<Int>(name: "month", capacity: 1))
            dataTable.append(column: Column<Int>(name: "dayOfWeek", capacity: 1))
            dataTable.append(column: Column<String>(name: "time", capacity: 1))
            dataTable.append(column: Column<String>(name: "fromStation", capacity: 1))
            //dataTable.append(column: Column<String>(name: "toStation", capacity: 1))
            let time = Date().formatted(date: .omitted, time: .complete)
            let components = dateComponents(Date())
            dataTable.append(valuesByColumn: ["time": time, "fromStation": currentStation.abbr, "month": components.month, "dayOfWeek": components.weekday])
            let results = try classifier.predictions(from: dataTable)
            
            print("ai result")
            debugPrint(results)
           // return results
        } catch {
            print("AI run ", error)
        }
    }
    public func dateComponents(_ date: Date) -> DateComponents {
       let components = Calendar.current.dateComponents([.month, .weekday], from: date)
        print(components)
        return components
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
