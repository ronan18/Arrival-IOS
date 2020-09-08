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
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HomeScreenHeader(geometry: geometry)
                StationChooserBar(fromStation: self.appState.fromStation, toStation: self.appState.toStation, timeMode: self.appState.tripTimeConfig, leftAction: {self.stationModalType = .from;  self.timeModal = false; self.stationModalPresented = true}, centerAction: {self.stationModalPresented = true; self.timeModal = true}, rightAction: {self.stationModalType = .to; self.timeModal = false; self.stationModalPresented = true}, skeleton:  self.appState.LocationServicesState == LocationServicesState.loading)
                AlertView(text: "California is under a mandatory shelter at home order during the Covid-19 pandemic. All non-essential travel should be avoided. BART is operating under a modified schedule and closes at 9pm. Weekday trains run every 30 minutes. Face coverings are required.", link: URL(string:"https://google.com"))
                Spacer()
                if (self.appState.LocationServicesState == LocationServicesState.askForLocation) {
                    LocationAccessRequest(clicked: {self.stationModalType = .from;  self.timeModal = false; self.stationModalPresented = true})
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
                            self.appState.fromStation = station
                            self.stationModalPresented = false}))
                    } else {
                        StationChooser(stations: self.appState.toStationSuggestions, type: self.stationModalType, close: {self.stationModalPresented = false}, choose: ({station in
                        print("choose",StationTypeName(self.stationModalType), station?.name);
                        self.appState.chooseToStation(station)
                        self.stationModalPresented = false}))
                    }
                    
                }
            }
            
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


