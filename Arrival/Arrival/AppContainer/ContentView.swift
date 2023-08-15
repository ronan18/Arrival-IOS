//
//  ContentView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.scenePhase) var scene: ScenePhase
    var body: some View {
        HomeScreen().environmentObject(appState).onChange(of: scene, perform: {scene in
            if (scene == .active) {
                Task {
                    
                    await self.appState.cycle()
                    self.appState.startTimer()
                    
                }
            } else {
                if (self.appState.timer != nil) {
                    self.appState.timer.invalidate()
                }
            }
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
