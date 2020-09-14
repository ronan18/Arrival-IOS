//
//  TrainsService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

public class TrainsService {
    public init () {
        
    }
  public  func sortTrains(_ trains: [Train]) -> [Train] {
        return trains.sorted(by: {
            $0.etd < $1.etd
        })
    }
   public func sortTrips(_ trips: [Trip]) -> [Trip] {
        return trips.sorted(by: {
                   $0.originTime < $1.originTime
               })
    }
}
