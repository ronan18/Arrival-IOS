//
//  Train.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/27/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct Train: Hashable, Codable, Identifiable {
    var id: UUID
    var direction: String
    var time: Int
    var unit: String
    var color: String
    var cars: Int
    var hex: String

  
   
}
