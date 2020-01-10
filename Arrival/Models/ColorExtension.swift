//
//  ColorExtension.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import UIKit
import  SwiftUI
func colorToColor(color: String) -> Color {
    
    if (color == "YELLOW") {
        return Color.yellow
    } else if (color == "BLUE") {
        return Color.blue
    } else if (color == "RED") {
        return Color.red
    } else if (color == "GREEN") {
        return Color.green
    } else if (color == "ORANGE") {
        return Color.orange
    } else if (color == "PURPLE") {
        return Color.purple
    } else {
        return Color.gray
    }
    
}
extension Color {
    //static let oldPrimaryColor = Color(UIColor.systemIndigo)
    static let lightDarkBG: Color = Color("lightDarkBG")
    static let whiteDark: Color = Color("whiteDark")
}

