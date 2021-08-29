//
//  StationSearchView.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalUI
public enum StationSearchMode {
    case from
    case to
}
public struct StationSearchView: View {
    @ObservedObject var appState: AppState
    
    @State var searchText: String = ""
    var mode: StationSearchMode

    public var body: some View {
        NavigationView() {
            List() {
                ForEach(self.mode == .to ? self.appState.toStationSuggestions :self.appState.closestStations) { station in
                    Button(action: {
                        switch (self.mode) {
                        case .from:
                            self.appState.setFromStation(station)
                            self.appState.fromStationChooser = false
                            return
                        case .to:
                            self.appState.setToStation(station)
                            self.appState.toStationChooser = false
                            return
                        }
                       
                    }) {
                    StationCard(appState: self.appState, station: station)
                    }.listRowSeparator(.hidden)
                    
                }
            }.listStyle(.plain).navigationBarTitle(self.mode == .to ? "To Station" : "From Station").navigationBarItems(trailing:Button(action: {
                switch (self.mode) {
                case .from:
                   
                    self.appState.fromStationChooser = false
                    return
                case .to:
                  
                    self.appState.toStationChooser = false
                    return
                }
            }) {
                Text("Cancel")
            }).navigationBarTitleDisplayMode(.large)
        }.searchable(text: self.$searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct StationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationSearchView(appState: AppState(), mode: .from)
    }
}
