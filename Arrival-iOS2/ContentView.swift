//
//  ContentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseCrashlytics

struct ContentView: View {
    @EnvironmentObject private var appData: AppData
  
    var body: some View {
        VStack {
            if (self.appData.ready) {
                if  (self.appData.network) {
                    if (self.appData.auth) {
                                      if (self.appData.screen == "home") {
                                            HomeView()
                                      } else if (self.appData.screen == "settings") {
                                          SettingsView()
                                      }
                                   
                                  } else {
                                      LoginView()
                                  }
                } else {
                    NoNetworkView()
                }
              
            } else {
                LoadingView()
            }
            
        }.onAppear(){
            print("main Appeared")
            self.appData.login()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppData())
    }
}
