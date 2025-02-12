//
//  Item.swift
//  Arrival
//
//  Created by Ronan Furuta on 2/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
