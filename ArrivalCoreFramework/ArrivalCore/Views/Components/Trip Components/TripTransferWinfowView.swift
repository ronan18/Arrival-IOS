//
//  TripTransferWinfowView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
public enum TripTransferWindowType {
    case transfer
    case board
    case arrive
}

public struct TripTransferWindow: View {
    let type: TripTransferWindowType
    var timeInterval: TimeInterval = TimeInterval(60)
    var time: Date = Date()
    var boardText: String = ""
   public init(type: TripTransferWindowType, timeInterval: TimeInterval = TimeInterval(60), time: Date = Date()) {
        self.type = type
        self.timeInterval = timeInterval
        self.time = time
        if (type == .board) {
            if (round(timeInterval / 60) == 0) {
                self.boardText = "Board now"
            } else if (timeInterval < 0) {
                self.boardText = "Boarded"
            } else if (Int(round(timeInterval / 60)) == 1){
                self.boardText = "Board in \(displayTimeInterval(timeInterval).time) minute"
            } else if (Int(round(timeInterval / 60)) > 60) {
                 self.boardText = "Board in \(displayTimeIntervalAllUnits(timeInterval))"
            }else {
                self.boardText = "Board in \(displayTimeInterval(timeInterval).time) minutes"
            }
        }
    }
    public var body: some View {
        HStack {
            if (type == .transfer) {
                Image(systemName: "clock")
                Text("\(displayTimeInterval(timeInterval).time) min transfer window")
            } else if (type == .board) {
                Image(systemName: "hourglass.bottomhalf.fill")
                Text(self.boardText)
            } else if (type == .arrive) {
                Image(systemName: "checkmark.circle")
                Text("Arrive by \(displayTime(time).time)\(displayTime(time).a)!")
            }
            
        }.font(.footnote)
    }
}

struct TripTransferWinfowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TripTransferWindow(type: .board, timeInterval: TimeInterval(60)).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TripTransferWindow(type: .board, timeInterval: TimeInterval(120)).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TripTransferWindow(type: .board, timeInterval: TimeInterval(120*60*5*5)).previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            TripTransferWindow(type: .board, timeInterval: TimeInterval(0)).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TripTransferWindow(type: .board, timeInterval: TimeInterval(-60)).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
        }
    }
}
