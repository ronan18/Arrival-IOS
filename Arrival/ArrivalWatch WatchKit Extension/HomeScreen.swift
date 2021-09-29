//
//  HomeScreen.swift
//  ArrivalWatch WatchKit Extension
//
//  Created by Ronan Furuta on 9/29/21.
// 

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var appState: WatchAppState

    var body: some View {
        NavigationView {
            if (self.appState.locationAuthState == .notAuthorized && self.appState.fromStation == nil) {
                AuthorizeLocationView(appState: appState)
            } else {
                HomeTrains(appState: appState).navigationBarTitle(self.appState.fromStation?.name ?? "No From Station")
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(appState: WatchAppState())
    }
}
