//
//  ScrollContentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct ScrollContentView: View {
    @EnvironmentObject var appState: AppState
    @State var trains: [Train]? = []
    @State var trips: [Trip]? = []
    @State var direction = 1
    @State var tripModalPresented = false
    @State var tripToPresent: Trip? = nil
    @State var stations: StationStorage = MockData().stationStorage
    var haptics: (()->())
    var cycle: (()->())
    var body: some View {
        VStack {
        if (self.trains?.count ?? 0 > 0) {
            Picker(selection: $direction, label: Text("Direction")) {
                Text("Northbound").tag(1)
                Text("Southbound").tag(2)
                Text("All").tag(3)
            }.pickerStyle(SegmentedPickerStyle()).padding([.leading, .trailing]).transition(.opacity).padding(.top)
        }
        
        ScrollView {
            if (self.appState.notificationCard != nil) {
                Spacer().frame(height: 10)
                NotificationCard(imageURL: self.appState.notificationCard!.image, title: self.appState.notificationCard!.title, message: self.appState.notificationCard!.message, actionURL: self.appState.notificationCard!.action, close: {self.appState.closeNotification(self.appState.notificationCard!.id)})
            }
        
            Spacer().frame(height: 10)
            if (self.trips?.count ?? 0 > 0) {
                TripsViewNoScroll(trips: trips!, presentTrip: {trip in
                    print("TRIP DETAIL: Presenting Trip", trip.origin.name)
                    self.tripToPresent = trip;
                    print("TRIP DETAIL: Presenting Trip final", self.tripToPresent?.origin.name ?? "error")
                    self.tripModalPresented = true;
                    self.haptics();
                    print("TRIP DETAIL: showing trip")
                    self.cycle()
                    
                }).sheet(isPresented: self.$tripModalPresented, content:{
                    ZStack {
                        if (self.tripToPresent != nil) {
                            TripDetailView(trip: self.tripToPresent!, close: {self.tripModalPresented = false}, stations: self.stations)
                        } else {
                            VStack {
                                Spacer()
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                Text("loading trip")
                                Text(String(self.tripToPresent != nil))
                                Spacer()
                            }
                        }
                    }.onAppear {
                        print("TRIP DETAIL: Modal Appear", self.tripToPresent != nil)
                     //   self.appState.cylce()
                    }
                    
                    
                })
            } else if(self.trains?.count ?? 0 > 0) {
                TrainsViewNoScroll(trains: self.trains!.filter({ train in
                    switch self.direction {
                    case 1:
                        return train.direction == .north
                    case 2:
                        return train.direction == .south
                    default:
                        return true
                    }
                })).onAppear {
                    print("scrollcontent: trains", self.trains?.count)
                    print("scrollcontent: trips", self.trips?.count)
                }
                
            } else {
                NoTrains()
            }
            
            
        }.padding(.horizontal).onAppear {
            if let trains = self.trains {
                var northTrains: [Train] = []
                var southTrains: [Train] = []
                    northTrains = trains.filter({$0.direction == .north})
                    if (northTrains.count == 0) {
                        self.direction = 2
                    }
                    southTrains = trains.filter({$0.direction == .south})
                    if (southTrains.count == 0) {
                        self.direction = 1
                    }
                }
            
        }
    }
    }
}

struct ScrollContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollContentView(trains: [], trips: MockData().trips, stations: MockData().stationStorage, haptics: {}, cycle: {})
    }
}
