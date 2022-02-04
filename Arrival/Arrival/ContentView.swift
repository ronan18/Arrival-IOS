//
//  ContentView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/20/21.
//

import SwiftUI
import ArrivalCore
import ArrivalUI
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var appState = AppState()
    var body: some View {
        ZStack {
            if (appState.screen == .onboard) {
                OnboardingView(appState: appState)
            } else if (appState.screen == .home) {
                HomeScreen(appState: appState)
            } else if (self.appState.screen == .noNetwork) {
                NoNetwork(retry: {
                    Task { await self.appState.startMain()}
                })
            } else if (appState.screen == .loading) {
                LoadingScreen(indicator: true, versionInfo: true)
            }
        }.onContinueUserActivity("TrainsToStationIntent", perform: {userActivity in
            guard let intent = userActivity.interaction?.intent as? TrainsToStationIntent else {
                return
            }
            guard let departureStationID = intent.departureStation?.identifier else {
                return
            }
            guard let destinationStationID = intent.destinationStation?.identifier else {
                return
            }
            print(departureStationID, destinationStationID, "user activity")
            self.appState.trainsIntent(departureStationID: departureStationID, destinationStationID: destinationStationID)
        }).onContinueUserActivity("TrainsFromStationIntent", perform: {userActivity in
            guard let intent = userActivity.interaction?.intent as? TrainsFromStationIntent else {
                return
            }
            guard let departureStationID = intent.fromStation?.identifier else {
                return
            }
          
            print(departureStationID, "user activity from station")
            self.appState.trainsIntent(departureStationID: departureStationID, destinationStationID: nil)
        }).onChange(of: scenePhase) { phase in
            
            // Handle errors here
                if (phase == .active) {
                    Task {
                        await self.appState.onAppear()
                    }
                }
        
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
