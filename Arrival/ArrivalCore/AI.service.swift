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
    var toStationModel: MLLogisticRegressionClassifier? = nil
    var directionFilterModel: MLLogisticRegressionClassifier? = nil
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
    public func logDirectionFilterEvent(_ event: DirectionFilterEvent) {
        self.diskService.storeDirectionFilterEvent(event)
    }
    public func trainDirectionFilterAI() async {
        print("runnin directionFilterAI")
        let events  = self.diskService.getDirectionFilterEvents()
        var dataTable: DataFrame = DataFrame()
        dataTable.append(column: Column<Int>(name: "month", capacity: events.count))
        dataTable.append(column: Column<Int>(name: "dayOfWeek", capacity: events.count))
        dataTable.append(column: Column<String>(name: "time", capacity: events.count))
        dataTable.append(column: Column<String>(name: "fromStation", capacity: events.count))
        dataTable.append(column: Column<String>(name: "direction", capacity: events.count))
       
        events.forEach {event in
           // print(event)
            let time  = event.date.formatted(date: .omitted, time: .complete)
            let components = dateComponents(event.date)
            
            dataTable.append(valuesByColumn: ["time": time, "fromStation": event.fromStation.abbr, "direction": event.direction.rawValue, "dayOfWeek": components.weekday, "month": components.month])
        }
        debugPrint(dataTable)
        do {
            
            let classifier = try MLLogisticRegressionClassifier(trainingData: dataTable, targetColumn: "direction")
          // try classifier.write(toFile: "tripStationAI.mlmodel", metadata: MLModelMetadata(author: "Ronan Furuta Arrival", shortDescription: "tripStation AI", license: nil, version: "1", additional: nil))
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let assetPath = documentsDirectory.appendingPathComponent("directionFilterAI.mlmodel")
                print(assetPath, "asset  ML path")
                try classifier.write(to: assetPath, metadata: MLModelMetadata(author: "Ronan Furuta Arrival", shortDescription: "directionFilter AI", license: nil, version: "1", additional: nil))
            }
           
           
           // let results = try classifier.predictions(from: dataTable)
            
            self.directionFilterModel = classifier
            //debugPrint(results)
           // self.predictDestinationStation(Station(id: "test", name: "ROCK", abbr: "ROCK", lat: 0, long: 0))
            
        }catch {
            print(error, "saving AI model")
        }
        
    }
    public func trainToStationAI() async {
        print("running to station training")
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
           // print(event)
            let time  = event.date.formatted(date: .omitted, time: .complete)
            let components = dateComponents(event.date)
            
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
           
           
           // let results = try classifier.predictions(from: dataTable)
            
            self.toStationModel = classifier
            //debugPrint(results)
           // self.predictDestinationStation(Station(id: "test", name: "ROCK", abbr: "ROCK", lat: 0, long: 0))
            
        }catch {
            print(error, "saving AI model")
        }
        
    }
    public func loadToStationModel() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let assetPath = documentsDirectory.appendingPathComponent("tripStationAI.mlmodel")
        print(assetPath)
       
        do {
           // Model
            print("AI COMPILING")
           let compile = try MLModel.compileModel(at: assetPath)
         print(compile)
          var model: MLModel = try MLModel(contentsOf: assetPath)
            print("got moddel")
           // model.prediction(from: <#T##MLFeatureProvider#>, options: <#T##MLPredictionOptions#>)
        } catch {
            print(error, "AI")
        }
       
        }
    }
    class ToStationModelInput: MLFeatureProvider {
        var featureNames: Set<String> = ["time", "fromStation", "month", "dayOfWeek"]
        let time: String
        let fromStation: String
        let month: Int
        let day: Int
        func featureValue(for featureName: String) -> MLFeatureValue? {
            switch featureName {
            case "time":
                return MLFeatureValue(string: self.time)
              //  return self.time
            case "fromStation":
                return MLFeatureValue(string: self.fromStation)
            case "month":
                return MLFeatureValue(int64: Int64(self.month))
               // return self.month
            case "dayOfWeek":
                return MLFeatureValue(int64: Int64(self.day))
                    // return self.day
            default:
                return nil
                
            }
            //return nil
        }
        
        init (time: String, fromStation: String, month: Int, day: Int) {
            self.time = time
            self.fromStation = fromStation
            self.month = month
            self.day = day
        }
    }
    public func predictDestinationStation(_ currentStation: Station) -> [StationProbibility]? {
      //  self.loadModel()
        guard let classifier = toStationModel else {
            self.loadToStationModel()
            return nil
        }
        
           
            let time = Date().formatted(date: .omitted, time: .complete)
            let components = dateComponents(Date())
         
            
            guard let classifierResults = try? classifier.model.prediction(from: ToStationModelInput(time: time, fromStation: currentStation.abbr, month: components.month!, day: components.weekday!)) else {
                print("error")
                return nil
            }
           /* classifierResults.featureNames.forEach {i in
                print(i, classifierResults.featureValue(for: i))
            }
            print( classifierResults.featureValue(for: "toStation"), classifierResults.featureNames)*/
            guard let toStationProbability = classifierResults.featureValue(for: "toStationProbability")?.dictionaryValue else {
                return nil
            }
            print(toStationProbability)
            var result: [StationProbibility] = []
            toStationProbability.keys.forEach {keyHash in
                
              //  print(keyHash as? String, toStationProbability[keyHash])
                guard let prob = toStationProbability[keyHash] as? Double, let key = keyHash as? String else {
                    return
                }
                print(key, prob)
                result.append(StationProbibility(id: key, prob: prob))
                
            }
           
            result.sort {a, b in
                return a.prob > b.prob
            }
            print(result)
            
             return result
           // return results
      
    }
    public func dateComponents(_ date: Date) -> DateComponents {
       let components = Calendar.current.dateComponents([.month, .weekday], from: date)
     //   print(components)
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
public let aiService = AIService()
