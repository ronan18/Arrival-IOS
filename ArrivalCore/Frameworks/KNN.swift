//
//  KNearestNeighborsClassifier.swift
//
//
//  Created by Baptiste Rousseau on 26/5/17.
//  Copyright © 2017 Rousseau. All rights reserved.
//

import Darwin
import Foundation
enum knnError: Error {
    case cantFindMajority
    case expectedNN(nNeighbors: Int, dataCount: Int)
     case expectedDataCount(dataCount: Int, labelsCount: Int)
    
}
public class KNearestNeighborsClassifier {
  
  private let data:           [[Double]]
  private let labels:         [Int]
  private let nNeighbors:     Int
  
  public init(data: [[Double]], labels: [Int], nNeighbors: Int = 3) throws  {
    self.data = data
    self.labels = labels
    self.nNeighbors = nNeighbors
    
    guard nNeighbors <= data.count else {
        throw(knnError.expectedNN(nNeighbors: nNeighbors, dataCount: data.count))
    }
    
    guard data.count == labels.count else {
        throw(knnError.expectedDataCount(dataCount: data.count, labelsCount: labels.count))
    }
  }
  
  public func predict(_ xTests: [[Double]]) throws -> [Int]  {
    do {
    return try xTests.map({
      let knn = kNearestNeighbors($0)
        do {
            let result = try kNearestNeighborsMajority(knn)
            return result
        } catch {
            throw(error)
        }
      
    })
    } catch {
    throw(error)
    }
  }
  
  private func distance(_ xTrain: [Double], _ xTest: [Double]) -> Double {
    let distances = xTrain.enumerated().map { index, _ in
      return pow(xTrain[index] - xTest[index], 2)
    }
    
    return distances.reduce(0, +)
  }
  
  private func kNearestNeighbors(_ xTest: [Double]) -> [(key: Double, value: Int)] {
    var NearestNeighbors = [Double : Int]()
    
    for (index, xTrain) in data.enumerated() {
      NearestNeighbors[distance(xTrain, xTest)] = labels[index]
    }
    
    let kNearestNeighborsSorted = Array(NearestNeighbors.sorted(by: { $0.0 < $1.0 }))[0...nNeighbors-1]
    
    return Array(kNearestNeighborsSorted)
  }
  
  private func kNearestNeighborsMajority(_ knn: [(key: Double, value: Int)]) throws -> Int {
    var labels = [Int :  Int]()
    
    for neighbor in knn {
      labels[neighbor.value] = (labels[neighbor.value] ?? 0) + 1
    }
    
    for label in labels {
      if label.value == labels.values.max() {
        return label.key
      }
    }
    
    throw(knnError.cantFindMajority)
  }
}
