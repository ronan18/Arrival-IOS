//
//  ContentView.swift
//  ArrivalWatch WatchKit Extension
//
//  Created by Ronan Furuta on 9/29/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appState: WatchAppState = WatchAppState()
    var body: some View {
        if (self.appState.screen == .loading) {
          LoadingScreen()
        } else {
            HomeScreen(appState: appState)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
