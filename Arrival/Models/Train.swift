//
//  Train.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct Train: Hashable, Codable, Identifiable {
    var id: Int
    var direction: String
    var time: String
    var unit: String
    var color: String
    
}
