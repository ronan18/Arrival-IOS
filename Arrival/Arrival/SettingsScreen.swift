//
//  SettingsScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 9/20/21.
//

import SwiftUI
import ArrivalCore
import ArrivalUI

struct SettingsScreen: View {
    @ObservedObject var appState: AppState
    @AppStorage("displayNavigationTime") var displayNavigationTime = true
    @State var isPresentingShareSheet = false
   
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: Form {
                    Section(footer:Text("Disabling this will reduce the amount of cellular data Arrival uses").foregroundColor(.gray)) {
                        Toggle("Display walking and driving time", isOn: $displayNavigationTime).foregroundColor(Color("TextColor"))
                    }
                  }.navigationTitle("Station Search")) {
                    Text("Station Search")
                }
                NavigationLink(destination: MachineLearningSettings()) {
                    Text("Machine Learning")
                }
                
                Section( header: Text("System Configuration")) {
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
                    Button(action: {
                        self.isPresentingShareSheet = true
                    }) {
                        Text("Share diagnostics configuration")
                    }.foregroundColor(.accentColor).shareSheet(isPresented: $isPresentingShareSheet, items: [self.appState.systemConfig()])
                   
                }
                HStack {
                    Spacer()
                ArrivalLegal()
                    Spacer()
                }
             
            }.foregroundColor(Color("TextColor")).navigationTitle("Arrival Settings").navigationBarItems(trailing:Button(action: {
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


struct MachineLearningSettings: View {
    var body: some View {
        
        VStack {
            Text("Arrival uses on device machine learning to automatically suggest and show BART information to you. This provides an easier and more intuitive user experience. To protect your privacy, all of this processing happens offline.").font(.subheadline)
                .foregroundColor(Color("TextColor")).padding(.horizontal)
        Form {
            
            Section(footer: Text("The Direction Filter AI predicts what train direction you are most likely to view and proactivly shows them.").foregroundColor(.gray)) {
                HStack {
                    Text("Direction Filter Events")
                    Spacer()
                    Text("\(aiService.directionFilterEventsCount)").textSelection(.enabled)
                }
                Button(role: .destructive, action: {}) {
                    Text("Reset Direction Filter AI")
                }.foregroundColor(.red)
            }
            Section(footer: Text("The Destination AI predicts which station you are most likely to travel to. It then increases the accuracy of your search results using this information.").foregroundColor(.gray)) {
                HStack {
                    Text("Destination Events")
                    Spacer()
                    Text("\(aiService.toStationEventsCount)").textSelection(.enabled)
                }
                Button(role: .destructive, action: {}) {
                    Text("Reset Destination AI")
                }.foregroundColor(.red)
            }
            
        }
            Spacer()
        }.background(Color("FormColor")).foregroundColor(Color("TextColor")).navigationTitle("Machine Learning")
        
    }
}
