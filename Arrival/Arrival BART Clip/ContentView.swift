//
//  ContentView.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI
import ArrivalCore
import ArrivalUI

struct ContentView: View {
    @StateObject var appState = AppClipState()
    var body: some View {
        if (self.appState.screen == .home) {
            HomeScreen(appState: appState)
        } else {
            Text("Loading")
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
