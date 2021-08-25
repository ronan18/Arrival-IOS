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
    @StateObject var appState = AppState()
    var body: some View {
        if (appState.screen == .onboard) {
            OnboardingView(appState: appState)
        } else if (appState.screen == .home) {
            HomeScreen(appState: appState)
        } else if (appState.screen == .loading) {
            ProgressView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
