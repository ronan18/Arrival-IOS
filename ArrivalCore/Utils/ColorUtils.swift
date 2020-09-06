//
//  ColorUtils.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
enum TrainColor {

    case red
    case green
    case orange
    case blue
    case purple
    case yellow
    case white
    case black
    
    
}

func converTrainColor(_ color: TrainColor) -> Color {
    
    switch color {
    case .red:
        return Color.red
    case .green:
    return Color.green
    case .orange:
    return Color.orange
    case .blue:
    return Color("arrivalBlue")
    case .purple:
    return Color.purple
    case .yellow:
    return Color.yellow
    case .white:
    return Color.white
    case .black:
    return Color.black
    }
    
}
