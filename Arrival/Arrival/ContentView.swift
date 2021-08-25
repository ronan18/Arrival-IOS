//
//  ContentView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/20/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState
    var body: some View {
        if (appState.screen == .onboard) {
            OnboardingView()
        } else {
            HomeScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appState: AppState())
    }
}
