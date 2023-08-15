//
//  StationChooser.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/11/23.
//

import SwiftUI

struct FromStationChooser: View {
    @EnvironmentObject var appState: AppState
    @State var search: String = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(self.appState.stations.filter({station in
                    guard search.count >= 1 else {
                        return true
                    }
                    return station.stopName.lowercased().contains(search.lowercased())
                })) {station in
                    Button(action: {
                        Task {
                            self.appState.fromStationChooser = false
                            await self.appState.updateFromStation(station)
                           
                        }
                    }) {
                        
                        StationCard(station: station).environmentObject(appState)
                    }.listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                }
            }.padding(.horizontal).navigationTitle("From Station").searchable(text: self.$search).listStyle(.plain).navigationBarItems(trailing:Button(action: {
                self.appState.fromStationChooser = false
            }) {
                Text("Close").foregroundColor(Color("TextColor"))
            }).navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StationChooser_Previews: PreviewProvider {
    static var previews: some View {
        FromStationChooser()
    }
}
