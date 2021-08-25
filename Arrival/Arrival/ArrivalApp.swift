//
//  ArrivalApp.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/20/21.
//

import SwiftUI
import ArrivalCore
import Network
import AlamofireNetworkActivityIndicator
@main
struct ArrivalApp: App {
   @StateObject var appState = AppState()
    
    init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
        }
    }
}
