//
//  TripTransferText.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
public enum TripTransferTextMode {
    case board
    case arrive
    case transferWindow
}
public struct TripTransferText: View {
    var time: Measurement<UnitDuration>? = nil
    var date: Date? = nil
    let mode: TripTransferTextMode
    public init(_ mode: TripTransferTextMode, interval: TimeInterval? = nil, date: Date? = nil) {
        self.mode = mode
        if let interval = interval {
            //print("transfer time interval \(interval) \(interval / 60)")
            self.time = Measurement(value: (interval / 60).rounded(), unit: UnitDuration.minutes)
        }
        if let date = date {
            self.date = date
        }
        if mode == .board {
            let timeBetween: TimeInterval = self.date!.timeIntervalSince(Date())
           // print(timeBetween, "time between \(self.date!) \(Date())")
            self.time = Measurement(value:  (timeBetween / 60).rounded(), unit: UnitDuration.minutes)
        }
        
    }
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            if (self.mode == .transferWindow) {
                Image(systemName: "clock")
                Text(" ") + Text(time!, format: .measurement(width: .wide))
            }
            if (self.mode == .board) {
                if (self.date! > Date()) {
                    Image(systemName: "clock")
                Text(" Board in ") + Text(time!, format: .measurement(width: .wide))
                } else {
                    Image(systemName: "checkmark.circle")
                    Text(" Boarded at ") + Text(date!, style: .time)
                }
            }
            if (self.mode == .arrive) {
                Image(systemName: "checkmark.circle")
                Text(" Arrive by ") + Text(date!, style: .time)
            }
            Spacer()
        }.font(.caption)
    }
}

struct TripTransferText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TripTransferText(.arrive,date: Date(timeIntervalSinceNow: 120))
            TripTransferText(.arrive,date: Date(timeIntervalSinceNow: 120))
        }
           
        
    }
}
