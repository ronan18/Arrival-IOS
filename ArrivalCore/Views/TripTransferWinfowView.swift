//
//  TripTransferWinfowView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
enum TripTransferWindowType {
    case transfer
    case board
    case arrive
}

struct TripTransferWindow: View {
    let type: TripTransferWindowType
    var timeInterval: TimeInterval = TimeInterval(60)
    var time: Date = Date()
    var body: some View {
        HStack {
            if (type == .transfer) {
                Image(systemName: "clock")
                Text("\(displayTimeInterval(timeInterval).time) min transfer window")
            } else if (type == .board) {
                Image(systemName: "hourglass.bottomhalf.fill")
                Text("Board in \(displayTimeInterval(timeInterval).time) minutes")
            } else if (type == .arrive) {
                Image(systemName: "checkmark.circle")
                Text("Arrive by \(displayTime(time).time)\(displayTime(time).a)!")
            }
            
        }.font(.footnote)
    }
}
