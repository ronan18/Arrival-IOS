//
//  ArrivalApp.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import SwiftUI

@main
struct ArrivalApp: App {
    @ObservedObject var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
