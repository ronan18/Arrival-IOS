//
//  ContentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Combine
import NotificationCenter
import ArrivalCoreFramework
struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {
        //   UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        ZStack {
            if (self.appState.configLoaded) {
                if (self.appState.screen == .loading) {
                    Loading()
                } else if (self.appState.screen == .loadingIndicator) {
                    Loading(indicator: true)
                } else if(self.appState.screen == .onBoarding) {
                    
                    OnBoarding(next: ({
                        self.appState.requestLocation()
                        self.appState.createAccount()
                        
                    }), config: self.appState.onBoardingConfig)
                    
                } else if(self.appState.screen == .home) {
                    VStack(spacing: 0) {
                        HomeScreen()
                    }
                } else if (self.appState.screen == .settings) {
                    SettingsScreen()
                }
                
                
            }else {
                Loading()
            }
           Text("").sheet(isPresented: self.$appState.linkedTripShown, content: {
                ZStack {
                    if (self.appState.linkedTripState == .loading || self.appState.stations == nil) {
                        VStack {
                            Spacer()
                            ActivityIndicator(style: .large)
                            Text("loading link...")
                            Spacer()
                        }
                    } else if (self.appState.linkedTripState == .ready) {
                        TripDetailView(trip: self.appState.linkedTrip!, close: {
                            self.appState.linkedTripShown = false
                        }, stations: self.appState.stations!)
                    } else {
                        VStack {
                            Spacer()
                            Text("Link expired").font(.largeTitle).fontWeight(.bold)
                            Text("Links older than a few days are automatically discarded").multilineTextAlignment(.center).padding(.vertical)
                            Spacer()
                            StyledButton(action:{  self.appState.linkedTripShown = false}, text: "OK")
                            
                            
                        }.padding()
                    }
                }
            })
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
