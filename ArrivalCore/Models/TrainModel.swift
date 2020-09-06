//
//  TrainModel.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI

enum TrainDirection {
    case north
    case south
}

func determineTrainDirection(_ direction: String) -> TrainDirection {
    switch direction {
    case "North", "north":
        return TrainDirection.north
    case "South", "south":
        return TrainDirection.south
    default:
        return TrainDirection.south
    }
}

func determineTrainColor(_ color: String) -> TrainColor {
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

struct Train: Identifiable {
   let id = UUID()
    let departureStation: Station
    let destinationStation: Station
    let etd: Date
    let platform: Int
    let direction: TrainDirection
    let delay: Double
    let bikeFlag: Int
    let color: TrainColor
}
