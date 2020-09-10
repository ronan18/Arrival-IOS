//
//  TripsView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TripsView: View {
    var trips: [Trip]
    var presentTrip: ((Trip)->())
    
    var body: some View {
        ZStack {
            if (trips.count == 0) {
                NoTrains()
            } else {
        ScrollView {
            Spacer().frame(height: 10)
            ForEach(trips) { trip in
                Button(action: {
                  
                    self.presentTrip(trip)
                }) {
                    TrainCard(trip: trip).padding(.horizontal)
                }.foregroundColor(Color("Text"))
                
            }
        }.edgesIgnoringSafeArea(.bottom)
            }
        }
        
        
    }
}


struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(trips:  MockData().trips, presentTrip: {trip in})
    }
}
