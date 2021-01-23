//
//  TimeService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

public class TimeService {
    public init() {
        
    }
   public func suggestTimes(fromStation: Station, toStation: Station?, time: Date) -> TimeSuggestion {
        return TimeSuggestion(leave: TripTimeModel(timeMode: .leave, time: Date(timeIntervalSinceNow: (15*60))), arrive: [TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (1*60*60))), TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (4*60*60))), TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (6*60*60))),TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (10*60*60))),TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (24*60*60)))])
    }
}
