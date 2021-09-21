//
//  HomeScreen.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI


struct HomeScreen: View {
    @ObservedObject var appState: AppClipState
    var body: some View {
        VStack(spacing: 0) {
            ArrivalClipHeader(appState: appState)
          ClipDestinationBar(appState: appState)
          
            Divider()
          
            if (self.appState.locationAuthState == .notAuthorized && self.appState.fromStation == nil) {
                ClipAuthorizeLocationView(appState: appState)
            } else {
               
                    ClipHomeTrainsView(appState: appState).edgesIgnoringSafeArea(.bottom)
                
           
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
        HomeScreen(appState: AppClipState())
    }
}
