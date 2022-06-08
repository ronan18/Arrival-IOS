//
//  TripBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import ArrivalCore
public struct TripBar: View {
    var trip: Trip
    public init(trip: Trip) {
        self.trip = trip
    }
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text("Departs").font(.caption)
                TimeDisplayText(self.trip.originTime, mode: .etd)
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Travel").font(.caption)
                TimeIntervalDisplayText(self.trip.tripTime)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Arrives").font(.caption)
                TimeDisplayText(self.trip.destinationTime, mode: .etd)
            }
           
        }.padding()
    }
}

struct TripBar_Previews: PreviewProvider {
    static var previews: some View {
        TripBar(trip: MockUpData().trip).previewLayout(.sizeThatFits)
    }
}
