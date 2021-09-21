//
//  SettingsScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 9/20/21.
//

import SwiftUI
import ArrivalCore

struct SettingsScreen: View {
    @ObservedObject var appState: AppState
    @AppStorage("displayNavigationTime") var displayNavigationTime = true
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("STATION SEARCH")) {
                    Toggle("Display walking and driving time", isOn: $displayNavigationTime)
                }
                Section(header: Text("MACHINE LEARNING DATA")) {
                    HStack {
                        Text("Direction Filter Events")
                        Spacer()
                        Text("\(aiService.directionFilterEventsCount)").textSelection(.enabled)
                    }
                    Button(role: .destructive, action: {}) {
                        Text("Reset Direction Filter Data")
                    }.controlSize(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/).foregroundColor(.red)
                    HStack {
                        Text("To Station Events")
                        Spacer()
                        Text("\(aiService.toStationEventsCount)").textSelection(.enabled)
                    }
                    Button(role: .destructive, action: {}) {
                        Text("Reset To Station Data")
                    }.controlSize(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/).foregroundColor(.red)
                }
                Section(header: Text("SYSTEM CONFIGURATION")) {
                    HStack {
                        Text("ID")
                        Spacer()
                        Text(self.appState.key ?? "NONE").textSelection(.enabled)
                    }
                    HStack {
                        Text("Mode")
                        Spacer()
                        Text(self.appState.mode == .production ? "production": "debug")  .textSelection(.enabled)
                    }
                    HStack {
                        Text("Stations Database")
                        Spacer()
                        Text("v\(self.appState.stations?.version ?? 0)c\(self.appState.stations?.stations.count ?? 0)")  .textSelection(.enabled)
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v\(self.appState.version)").textSelection(.enabled)
                    }
                    Button(action: {}) {
                        Text("Export Configuration")
                    }.foregroundColor(.accentColor).controlSize(/*@START_MENU_TOKEN@*/.small/*@END_MENU_TOKEN@*/)
                }
            }.navigationTitle("Arrival Settings").navigationBarItems(trailing:Button(action: {
                self.appState.settingsModal = false
            }) {
                Text("Done").foregroundColor(Color("TextColor"))
            })
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(appState: AppState())
    }
}
