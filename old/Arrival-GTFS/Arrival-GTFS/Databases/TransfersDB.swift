//
//  TransfersDB.swift
//  Arrival-GTFS
//
//  Created by Ronan Furuta on 2/15/25.
//

import Foundation
public struct TransfersDB: Codable, Hashable, Equatable {
   
    
    public let all: [Transfer]
    private let byStopIDIndex: [String: [Int]]
    init() {
        self.all = []
        self.byStopIDIndex = [:]
    }
    public init(from transfers: [Transfer]) {
        self.all = transfers
        var byStopID: [String: [Int]] = [:]
        for i in 0..<all.count {
           let transfer = all[i]
            var current = byStopID[transfer.topStopId] ?? []
            current.append(i)
            byStopID[transfer.fromStopId] = current
        }
        self.byStopIDIndex = byStopID
    }
    public func byStopID(_ stopId: String) -> [Transfer]? {
        guard let index = self.byStopIDIndex[stopId] else {
            return nil
        }
        return index.map({i in
            return all[i]
        })
    }
}
