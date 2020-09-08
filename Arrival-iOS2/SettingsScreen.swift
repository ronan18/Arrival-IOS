//
//  SettingsScreen.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var appState: AppState
    @State var stationVersion: String = ""
    @State   var stationCount: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                SettingsScreenHeader(geometry:geometry, back: {
                    self.appState.screen = .home
                })
                List {
                    HStack() {
                        Text("App ID")
                        Spacer()
                        Text(self.appState.key).font(.caption).lineLimit(1)
                    }
                    HStack() {
                        Text("Station Version")
                        Spacer()
                        Text(self.stationVersion)
                    }
                    HStack() {
                        Text("Station Count")
                        Spacer()
                        Text(self.stationCount)
                    }
                    HStack() {
                        Text("To Station Events")
                        Spacer()
                        Text(String(self.appState.toStationEvents.count))
                    }
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top).onAppear {
            self.stationVersion = String(self.appState.stations?.version ?? 0)
            self.stationCount = String(self.appState.stations?.stations.count ?? 0)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
