//
//  HomeScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import Foundation
import Combine
import ArrivalUI
import ArrivalCore

struct HomeScreen: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            ArrivalHeader(appState: appState)
            DestinationBar(appState: appState)
            if (self.appState.message != nil) {
                HeaderAlert(message: self.appState.message!)
            }
            if (self.appState.locationAuthState == .notAuthorized && self.appState.fromStation == nil) {
                AuthorizeLocationView(appState: appState)
            } else {
                if (self.appState.toStation != nil) {
                    HomeTrips(appState: appState).edgesIgnoringSafeArea(.bottom)
                } else {
                    HomeTrains(appState: appState).edgesIgnoringSafeArea(.bottom)
                }
           
            }
            Spacer()
        }.edgesIgnoringSafeArea(.bottom).task(priority: .userInitiated) {
            print("home appeared")
            await self.appState.cycle()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(appState: AppState())
    }
}


