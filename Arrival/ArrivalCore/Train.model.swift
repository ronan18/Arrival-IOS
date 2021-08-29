//
//  Train.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/23/21.
//

import Foundation
import SwiftUI

public enum TrainDirection {
    case north
    case south

}
public enum TrainColor: String {
    case yellow = "yellow"
    case red = "red"
    case green = "green"
    case blue = "blue"
    case orange = "orange"
    case purple = "purple"
    case white = "white"
    case black = "black"
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
public func turnTrainColorToColor(_ trainColor: TrainColor) -> Color{
    switch trainColor {
    case .yellow:
        return .yellow
    case .blue:
        return .blue
    case .red :
        return .red
    case .green:
        return .green
    case .orange:
        return .orange
    case .purple:
        return .purple
    case .white:
        return .white
    default:
        return .black
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

public struct Train: Identifiable, Equatable {
    public let id = UUID()
    public let departureStation: Station
    public let destinationStation: Station
    public let etd: Date
    public let platform: Int
    public let direction: TrainDirection
    public let delay: Double
    public let bikeFlag: Int
    public let color: TrainColor
    public let colorData: Color
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
        self.colorData = turnTrainColorToColor(color)
    }
}
