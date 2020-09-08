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
    @State var stationModalPresented = false
    @State var stationModalType: StationType = .from
    @State var timeModal = false
    @State var locationTimeout = false
    
    init() {
       // UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HomeScreenHeader(geometry: geometry, settings: {self.appState.screen = .settings})
                StationChooserBar(fromStation: self.appState.fromStation, toStation: self.appState.toStation, timeMode: self.appState.tripTimeConfig, leftAction: {self.stationModalType = .from;  self.timeModal = false; self.stationModalPresented = true}, centerAction: {self.stationModalPresented = true; self.timeModal = true}, rightAction: {self.stationModalType = .to; self.timeModal = false; self.stationModalPresented = true}, skeleton:  self.appState.locationServicesState == LocationServicesState.loading && !self.locationTimeout && self.appState.fromStation == nil, geometry: geometry)
                if (self.appState.bannerAlert != nil) {
                    AlertView(text: self.appState.bannerAlert?.content ?? "", link: self.appState.bannerAlert?.link)
                }
               
                Spacer()
                if (self.appState.locationServicesState == LocationServicesState.askForLocation && self.appState.fromStation == nil) {
                    PleaseChooseFromStation(locationAlert: true, clicked: {self.stationModalType = .from;  self.timeModal = false; self.stationModalPresented = true})
                } else if (self.appState.fromStation == nil && self.locationTimeout) {
                  PleaseChooseFromStation(locationAlert: false, clicked: {self.stationModalType = .from;  self.timeModal = false; self.stationModalPresented = true})
                }
            }.sheet(isPresented: self.$stationModalPresented) {
                if (self.timeModal) {
                    TimeOptions(options: sampleTimeOptions, close: {
                        self.stationModalPresented = false
                        self.timeModal = false
                    })
                } else {
                    if (self.stationModalType == .from) {
                        StationChooser(stations: self.appState.fromStationSuggestions, type: self.stationModalType, close: {self.stationModalPresented = false}, choose: ({station in
                            print("choose",StationTypeName(self.stationModalType), station?.name);
                            self.appState.chooseFromStation(station!)
                            self.stationModalPresented = false}))
                    } else {
                        StationChooser(stations: self.appState.toStationSuggestions, type: self.stationModalType, close: {self.stationModalPresented = false}, choose: ({station in
                        print("choose",StationTypeName(self.stationModalType), station?.name);
                        self.appState.chooseToStation(station)
                        self.stationModalPresented = false}))
                    }
                    
                }
            }
            
        }.edgesIgnoringSafeArea(.top).onAppear {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
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


