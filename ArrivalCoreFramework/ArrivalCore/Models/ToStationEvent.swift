//
//  FromStationEvent.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

public struct ToStationEvent: Codable {
    public let fromStation: Station
    public let toStation: Station
    public let time: Date
    public init(fromStation: Station, toStation: Station,time: Date) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.time = time
    }
}
