//
//  ML.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct MLObject {
    let model: KNearestNeighborsClassifier?
    let key: [Int: Station]
}

class MLService {
    var model: KNearestNeighborsClassifier? = nil
    var decodeTable:[Int: Station]? = nil
    var encodeTable:[Station: Int]? = nil
    
    func train(_ inputData: [ToStationEvent]) -> MLObject {
        var trainingLabels: [Int] = [] // by abbr
        var trainingData: [[Double]] = [] // from station, day, hour
        var key: [Int: Station] = [:]
        var conversionTableWorking: [Station: Int] = [:]
        var counter = 1
        inputData.forEach({event in
            let date = event.time
            let fromStation = event.fromStation
            let toStation = event.toStation
            let day = Double(Calendar.current.component(.weekday, from: date) as Int)
            let hour = Double(Calendar.current.component(.hour, from: date) as Int)
            var fromStationId: Double
            var toStationId: Int
            
            if (conversionTableWorking[fromStation] != nil) {
                fromStationId = Double(conversionTableWorking[fromStation]!)
            } else {
                counter += 1
                conversionTableWorking[fromStation] = counter
                key[counter] = fromStation
                fromStationId = Double(counter)
                
            }
            if (conversionTableWorking[toStation] != nil) {
                
                toStationId = conversionTableWorking[toStation]!
            } else {
                counter += 1
                conversionTableWorking[toStation] = counter
                key[counter] = toStation
                toStationId = counter
            }
            
            trainingData.append([fromStationId, day, hour])
            trainingLabels.append(toStationId)
        })
        var model:KNearestNeighborsClassifier?
        do {
            print("ml KNN count", trainingData.count - 1)
            model =  try KNearestNeighborsClassifier(data: trainingData, labels: trainingLabels, nNeighbors: 1)
            self.model = model
            self.decodeTable = key
            self.encodeTable = conversionTableWorking
        } catch {
            print(error, "ml error")
            model  = nil
        }
        
        let result = MLObject(model: model, key: key)
       // print("trained ml", result)
        return result
    }
    func predict(fromStation: Station, date: Date = Date()) -> [Station]? {
        if let key = self.encodeTable {
            if let model = self.model {
                
                let day = Double(Calendar.current.component(.weekday, from: date) as Int)
                let hour = Double(Calendar.current.component(.hour, from: date) as Int)
                if let fromStationId: Int = key[fromStation] {
                    do {
                        let labels = try model.predict([[Double(fromStationId), day, hour]])
                        print(labels, "ml predicted labels")
                        var result: [Station] = []
                        labels.forEach({label in
                            print("ml lable", label)
                            if let station = self.decodeTable?[label] {
                                   result.append(station)
                            }
                         
                        })
                        print("ml result", result)
                        return result
                    } catch {
                        print("ml prediction error", error)
                    }
                } else {
                    return nil
                }
                
                
                
            } else {
                return nil
            }
        } else {
            return nil
        }
        return nil
        
    }
}
