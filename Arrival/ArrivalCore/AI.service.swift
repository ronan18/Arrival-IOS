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
#if targetEnvironment(simulator)
public class AIService{
    public func predictDestinationStation(_ currentStation: Station) -> [StationProbibility]? {
        print("DEBUG AI results")

        return []
    }
    public func predictDirectionFilter(_ currentStation: Station) -> TrainDirection? {
        print("DEBUG AI results")
        let number = Int.random(in: 0...2)
        if (number == 1) {
            return .north
        } else if (number == 2) {
            return .south
        }
        return nil
    }
    public func trainToStationAI() async {
        return
    }
    public func trainDirectionFilterAI() async {
        return
    }
    public func logDirectionFilterEvent(_ event: DirectionFilterEvent) {
        return
    }
    public func logTripEvent(_ event: TripEvent) {
        return
    }
}
#else
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
        dataTable.append(column: Column<Int>(name: "hour", capacity: events.count))
        dataTable.append(column: Column<String>(name: "fromStation", capacity: events.count))
        dataTable.append(column: Column<String>(name: "direction", capacity: events.count))
       
        events.forEach {event in
           // print(event)
            let time  = event.date.formatted(date: .omitted, time: .complete)
            let components = dateComponents(event.date)
            
            dataTable.append(valuesByColumn: ["hour": components.hour, "fromStation": event.fromStation.abbr, "direction": event.direction.rawValue, "dayOfWeek": components.weekday, "month": components.month])
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
        dataTable.append(column: Column<Int>(name: "hour", capacity: events.count))
        dataTable.append(column: Column<String>(name: "fromStation", capacity: events.count))
        dataTable.append(column: Column<String>(name: "toStation", capacity: events.count))
        // dataTable.append(valuesByColumn: ["time": "now", "fromStation": "test from", "toStation": "toStationTest"])
        // dataTable.append(row: ["test", "test", "test"])
        // dataTable.append(row: ["test2", "test2", "test2"])
        events.forEach {event in
           // print(event)
           // let time  = event.date.formatted(date: .omitted, time: .complete)
            let components = dateComponents(event.date)
            
            dataTable.append(valuesByColumn: ["hour": components.hour, "fromStation": event.fromStation.abbr, "toStation": event.toStation.abbr, "dayOfWeek": components.weekday, "month": components.month])
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
          let model: MLModel = try MLModel(contentsOf: assetPath)
            print("got moddel", model.description)
           // model.prediction(from: <#T##MLFeatureProvider#>, options: <#T##MLPredictionOptions#>)
        } catch {
            print(error, "AI")
        }
       
        }
    }
    class ToStationModelInput: MLFeatureProvider {
        var featureNames: Set<String> = ["hour", "fromStation", "month", "dayOfWeek"]
        let hour: Int
        let fromStation: String
        let month: Int
        let day: Int
        func featureValue(for featureName: String) -> MLFeatureValue? {
            switch featureName {
            case "hour":
                return MLFeatureValue(int64: Int64(self.hour))
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
        
        init (hour: Int, fromStation: String, month: Int, day: Int) {
            self.hour = hour
            self.fromStation = fromStation
            self.month = month
            self.day = day
        }
    }
    class DirectionFilterModelInput: MLFeatureProvider {
        var featureNames: Set<String> = ["hour", "fromStation", "month", "dayOfWeek"]
       
        let hour: Int
        let fromStation: String
        let month: Int
        let day: Int
        func featureValue(for featureName: String) -> MLFeatureValue? {
            switch featureName {
            case "hour":
                return MLFeatureValue(int64: Int64(self.hour))
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
            
        
    }
        init (hour: Int, fromStation: String, month: Int, day: Int) {
            self.hour = hour
            self.fromStation = fromStation
            self.month = month
            self.day = day
        }
    }
    public func predictDirectionFilter(_ currentStation: Station) -> TrainDirection? {
        print("prediction direction filter")
        guard let classifier = directionFilterModel else {
            return nil
        }
      //  let time = Date().formatted(date: .omitted, time: .complete)
        let components = dateComponents(Date())
        guard let classifierResults = try? classifier.model.prediction(from: ToStationModelInput(hour: components.hour ?? 0, fromStation: currentStation.abbr, month: components.month ?? 0, day: components.weekday ?? 0)) else {
            print("error direction filter")
            return nil
        }
       // debugPrint(classifierResults.featureValue(for: "direction"), "direction filter features")
        if let directionString = classifierResults.featureValue(for: "direction")?.stringValue {
            switch directionString {
            case "north":
                return  .north
            case "south":
                return .south
            default:
                return  nil
            }
        }
        return nil
        
    }
    public func predictDestinationStation(_ currentStation: Station) -> [StationProbibility]? {
      //  self.loadModel()
        guard let classifier = toStationModel else {
            self.loadToStationModel()
            return nil
        }
        
           
          //  let time = Date().formatted(date: .omitted, time: .complete)
            let components = dateComponents(Date())
         
            
        guard let classifierResults = try? classifier.model.prediction(from: ToStationModelInput(hour: components.hour ?? 0, fromStation: currentStation.abbr, month: components.month ?? 0, day: components.weekday ?? 0)) else {
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
        let components = Calendar.current.dateComponents([.month, .weekday, .hour], from: date)
     //   print(components)
        return components
    }
}
#endif
public let aiService = AIService()
