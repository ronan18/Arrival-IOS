//
//  StationSearchView.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
public enum StationSearchMode {
    case from
    case to
}
public struct StationSearchView: View {
    @ObservedObject var appState: AppState
    
    @State var searchText: String = ""
    var mode: StationSearchMode
    func searchFilter(_ term: String, station: Station) -> Bool {
        let cleanedTerm = term.lowercased()
        let name = station.name.lowercased()
        guard cleanedTerm.count > 0 else {
            return true
        }
        print(name, cleanedTerm)
        return name.contains(cleanedTerm)
        
    }
    public var body: some View {
        NavigationView() {
            List() {
                if (mode == .to) {
                    Button(action: {
                        self.appState.setToStation(nil)
                        self.appState.toStationChooser = false
                    }) {
                    HStack {
                        
                        HStack {
                            Text("None").font(.headline).lineLimit(1)
                            Spacer()
                         }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("DarkText"))
                    }.cornerRadius(10).background(Color("CardBG")).overlay(
                        RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
                    ).cornerRadius(10.0)
                    }.listRowSeparator(.hidden)
                }
                ForEach(self.mode == .to ? self.appState.toStationSuggestions.filter({a in searchFilter(self.searchText, station: a)}) : self.appState.closestStations.filter({a in searchFilter(self.searchText, station: a)})) { station in
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
                Text("Cancel").foregroundColor(Color("TextColor"))
            }).navigationBarTitleDisplayMode(.large)
        }.searchable(text: self.$searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct StationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationSearchView(appState: AppState(), mode: .from)
    }
}
