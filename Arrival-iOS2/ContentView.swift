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

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        VStack {
            if (self.appState.screen == .loading) {
                Loading()
            } else if (self.appState.screen == .loadingIndicator) {
                Loading(indicator: true)
            } else if(self.appState.screen == .onBoarding) {
                
                OnBoarding(next: ({
                    self.appState.requestLocation()
                    self.appState.createAccount()
                    
                }))
                
            } else if(self.appState.screen == .home) {
                VStack(spacing: 0) {
                    HomeScreen()
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
