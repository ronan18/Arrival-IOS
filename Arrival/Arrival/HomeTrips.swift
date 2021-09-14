//
//  HomeTrips.swift
//  HomeTrips
//
//  Created by Ronan Furuta on 8/29/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct HomeTrips: View {
    @ObservedObject var appState: AppState
    @State var timeDisplayMode = TimeDisplayType.etd
    
    var body: some View {
        VStack {
            if (self.appState.trainsLoading) {
                List() {
                    ForEach(0..<5) {i in
                        TrainCard(train: MockUpData().train, timeDisplayMode: self.$timeDisplayMode, redacted: true).redacted(reason: .placeholder).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                    }
                   
                    
                }.listStyle(.plain)
            } else {
                if (self.appState.trips.count > 0) {
            List() {
               
                ForEach(self.appState.trips) {trip in
              
                   
                           //Text("test")
                    Button(action: {
                        
                        print("displaying from click")
                        self.appState.diplayTripModal = true
                        self.appState.tripDisplay = trip
                    }) {
                    TrainCard(train: trip.legs.first!.trainData, timeDisplayMode: self.$timeDisplayMode, eta: trip.destinationTime)
                    }.contentShape(Rectangle()).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5).buttonStyle(PlainButtonStyle())  
                
              
                   
                }.edgesIgnoringSafeArea(.bottom)
                
            }.listStyle(.plain).refreshable {
                Task(priority: .userInitiated) {
                    await self.appState.cycle()
                }
            }.edgesIgnoringSafeArea(.bottom)
            } else {
                VStack {
                    Spacer()
                    Text("No Trips in this direction")
                    Spacer()
                }
            }
            }
        }.padding().edgesIgnoringSafeArea(.bottom).sheet(isPresented: .init(get: {
            return self.appState.diplayTripModal
        }, set: {
         
                self.appState.diplayTripModal = $0
            
        })) {
            TripDetailsView(appState: appState)
        }
    }
}

struct HomeTrips_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrips(appState: AppState())
    }
}
