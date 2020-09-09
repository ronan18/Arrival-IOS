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
    @State var stationModalType: StationType = .from
    @State var timeModal = false
    @State var locationTimeout = false
    @State var tripToPresent: Trip?
    init() {
        // UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HomeScreenHeader(geometry: geometry, settings: {self.appState.screen = .settings})
                StationChooserBar(fromStation: self.appState.fromStation, toStation: self.appState.toStation, timeMode: self.appState.tripTimeConfig, leftAction: {self.stationModalType = .from; self.tripToPresent = nil;  self.timeModal = false; self.modalPresented = true}, centerAction: {self.tripToPresent = nil;  self.timeModal = true; self.modalPresented = true;}, rightAction: {self.stationModalType = .to;self.tripToPresent = nil;  self.timeModal = false; self.modalPresented = true}, skeleton:  self.appState.locationServicesState == LocationServicesState.loading && !self.locationTimeout && self.appState.fromStation == nil, geometry: geometry)
                if (self.appState.bannerAlert != nil) {
                    AlertView(text: self.appState.bannerAlert?.content ?? "", link: self.appState.bannerAlert?.link)
                }
                
                
                if (self.appState.locationServicesState == LocationServicesState.askForLocation && self.appState.fromStation == nil) {
                    PleaseChooseFromStation(locationAlert: true, clicked: {self.stationModalType = .from;  self.timeModal = false; self.modalPresented = true})
                } else if (self.appState.fromStation == nil && self.locationTimeout) {
                    PleaseChooseFromStation(locationAlert: false, clicked: {self.stationModalType = .from;  self.timeModal = false; self.modalPresented = true})
                } else if (self.appState.trains != nil) {
                    TrainsView(trains: self.appState.trains!).edgesIgnoringSafeArea(.bottom)
                    
                } else if (self.appState.trips != nil) {
                    TripsView(trips: self.appState.trips!, presentTrip: {trip in self.tripToPresent = trip; self.modalPresented = true; self.appState.buttonHaptics(); print("showing trip")}).edgesIgnoringSafeArea(.bottom)
                    
                } else {
                    SkeletonLoading()
                }
                Spacer()
            }.edgesIgnoringSafeArea(.bottom).sheet(isPresented: self.$modalPresented) {
                VStack {
                    if (self.timeModal) {
                        TimeOptions(options: sampleTimeOptions, close: {
                            self.modalPresented = false
                            self.timeModal = false
                        })
                    } else if (self.tripToPresent != nil) {
                        TripDetailView(trip: self.tripToPresent!, close: {self.modalPresented = false}, stations: self.appState.stations!)
                    }else if (self.stationModalType == .from) {
                        StationChooser(stations: self.appState.fromStationSuggestions, type: self.stationModalType, close: {self.modalPresented = false}, choose: ({station in
                            print("choose",StationTypeName(self.stationModalType), station?.name);
                            self.appState.chooseFromStation(station!)
                            self.modalPresented = false}))
                    } else if (self.stationModalType == .to) {
                        StationChooser(stations: self.appState.toStationSuggestions, type: self.stationModalType, close: {self.modalPresented = false}, choose: ({station in
                            print("choose",StationTypeName(self.stationModalType), station?.name);
                            self.appState.chooseToStation(station)
                            self.modalPresented = false}))
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Loading")
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        
                        
                    }
                }
            }
            
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



