//
//  TrainModel.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI

public enum TrainDirection {
    case north
    case south
}

public func determineTrainDirection(_ direction: String) -> TrainDirection {
    switch direction {
    case "North", "north":
        return TrainDirection.north
    case "South", "south":
        return TrainDirection.south
    default:
        return TrainDirection.south
    }
}

public func determineTrainColor(_ color: String) -> TrainColor {
    switch color.lowercased() {
    case "yellow":
        return TrainColor.yellow
    case "blue":
        return TrainColor.blue
    case "red" :
        return .red
    case "green":
        return .green
    case "orange":
        return .orange
    case "purple":
        return .purple
    case "white":
        return .white
    default:
        return TrainColor.black
    }
}

public struct Train: Identifiable {
    public let id = UUID()
    public let departureStation: Station
    public let destinationStation: Station
    public let etd: Date
    public let platform: Int
    public let direction: TrainDirection
    public let delay: Double
    public let bikeFlag: Int
    public let color: TrainColor
    public let cars: Int
    public init(departureStation: Station, destinationStation: Station,etd: Date, platform: Int,direction: TrainDirection, delay: Double,bikeFlag: Int,color: TrainColor,cars: Int) {
        self.departureStation = departureStation
        self.destinationStation = destinationStation
        self.etd = etd
        self.platform = platform
        self.direction = direction
        self.delay = delay
        self.bikeFlag = bikeFlag
        self.color = color
        self.cars = cars
    }
}
