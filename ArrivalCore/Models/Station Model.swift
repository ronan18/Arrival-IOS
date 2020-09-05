//
//  Station Model.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

struct Station: Identifiable {
    let id: String
    let name: String
    let abbr: String
    var lat: Double? = nil
    var long: Double? = nil
    
}
