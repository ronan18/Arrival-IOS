//
//  tripTime.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

enum TimeMode {
    case leave
    case arrive
    case now
}

struct TripTimeModel {
    var timeMode: TimeMode
    var time: Date
}
