//
//  TripsViewNoScroll.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public struct TripsViewNoScroll: View {
    var trips: [Trip]
    var presentTrip: ((Trip)->())
    public init(trips: [Trip], presentTrip: @escaping ((Trip)->())) {
        self.trips = trips
        self.presentTrip = presentTrip
    }
    public var body: some View {
        

        
      
        ForEach(trips) { trip in
            Button(action: {
                
                self.presentTrip(trip)
            }) {
                TrainCard(trip: trip)
            }.foregroundColor(Color("Text"))
            
        }
        
        
        
    }
}

struct TripsViewNoScroll_Previews: PreviewProvider {
    static var previews: some View {
        TripsViewNoScroll(trips:  MockData().trips, presentTrip: {trip in})
    }
}
