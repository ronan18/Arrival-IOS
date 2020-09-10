//
//  HomeScreen.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
struct HomeScreen: View {
    @EnvironmentObject private var appState: AppState
    @State var modalPresented = false
    @State var fromStationModalPresented = false
    @State var toStationModalPresented = false
    @State var timeModalPresented = false
    @State var tripModalPresented = false
    @State var stationModalType: StationType = .from
    @State var timeModal = false
    @State var locationTimeout = false
    @State var tripToPresent: Trip? = nil
    init() {
        // UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HomeScreenHeader(geometry: geometry, settings: {self.appState.screen = .settings})
                StationChooserBar(fromStation: self.appState.fromStation, toStation: self.appState.toStation, timeMode: self.appState.tripTimeConfig, leftAction: {self.fromStationModalPresented = true; print("show from station modal")}, centerAction: {self.timeModalPresented = true}, rightAction: {self.toStationModalPresented = true}, skeleton:  self.appState.locationServicesState == LocationServicesState.loading && !self.locationTimeout && self.appState.fromStation == nil, geometry: geometry)
                if (self.appState.bannerAlert != nil) {
                    AlertView(text: self.appState.bannerAlert?.content ?? "", link: self.appState.bannerAlert?.link)
                }
                
                
                if (self.appState.locationServicesState == LocationServicesState.askForLocation && self.appState.fromStation == nil) {
                    PleaseChooseFromStation(locationAlert: true, clicked: {self.fromStationModalPresented = true})
                } else if (self.appState.fromStation == nil && self.locationTimeout) {
                    PleaseChooseFromStation(locationAlert: false, clicked: {self.fromStationModalPresented = true})
                } else if (self.appState.trains != nil) {
                    TrainsView(trains: self.appState.trains!).edgesIgnoringSafeArea(.bottom)
                    
                } else if (self.appState.trips != nil) {
                    TripsView(trips: self.appState.trips!, presentTrip: {trip in
                        print("presenting trip:", trip)
                        self.tripToPresent = trip;
                        print("presenting trip final:", self.tripToPresent)
                        self.tripModalPresented = true; self.appState.buttonHaptics(); print("showing trip")
                        
                    }).edgesIgnoringSafeArea(.bottom)
                    
                } else {
                    SkeletonLoading()
                }
                Spacer()
                ZStack {
                    Text("").sheet(isPresented: self.$fromStationModalPresented) {
                        StationChooser(stations: self.appState.fromStationSuggestions, type: .from, close: {self.fromStationModalPresented = false}, choose: ({station in
                                                                                                                                                                print("choose",StationTypeName(self.stationModalType), station?.name);
                                                                                                                                                                self.appState.chooseFromStation(station!)
                                                                                                                                                                self.fromStationModalPresented = false}))
                    }
                    Text("").sheet(isPresented: self.$toStationModalPresented, content: {
                        StationChooser(stations: self.appState.toStationSuggestions, type: .to, close: {self.toStationModalPresented = false}, choose: ({station in
                                                                                                                                                            print("choose",StationTypeName(self.stationModalType), station?.name);
                                                                                                                                                            self.appState.chooseToStation(station)
                                                                                                                                                            self.toStationModalPresented = false}))
                    })
                    Text("").sheet(isPresented: self.$timeModalPresented, content: {
                        TimeOptions(options: sampleTimeOptions, close: {
                            self.timeModalPresented = false
                        })
                    })
                    Text("").sheet(isPresented: self.$tripModalPresented, content:{
                        if (self.tripToPresent != nil) {
                            TripDetailView(trip: self.tripToPresent!, close: {self.tripModalPresented = false}, stations: self.appState.stations!)
                        } else {
                            VStack {
                                Spacer()
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                Text("loading trip")
                                Spacer()
                            }
                        }
                        
                        
                    })
                }
            }.edgesIgnoringSafeArea(.bottom)
            
        }.edgesIgnoringSafeArea([.top, .bottom]).onAppear {
            self.appState.cylce()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                self.locationTimeout = true
                
            }
        }
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}



