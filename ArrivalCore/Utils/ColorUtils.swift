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
func converTrainColorToHuman(_ color: TrainColor) -> String {
    switch color {
      case .red:
          return "Red"
      case .green:
      return "Green"
      case .orange:
      return "orange"
      case .blue:
      return "Blue"
      case .purple:
      return "Purple"
      case .yellow:
      return "Yellow"
      case .white:
      return "White"
      case .black:
      return "Black"
      }
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
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
