//
//  ClipStationSearchView.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct ClipStationSearchView: View {
    @ObservedObject var appState: AppClipState
    
    @State var searchText: String = ""
  
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
                
                ForEach(self.appState.fromStationSuggestions.filter({a in searchFilter(self.searchText, station: a)})) { station in
                    Button(action: {
                      
                            self.appState.setFromStation(station)
                            self.appState.fromStationChooser = false
                            return
                       
                       
                    }) {
                    ClipStationCard(appState: self.appState, station: station)
                    }.listRowSeparator(.hidden)
                    
                }
            }.listStyle(.plain).navigationBarTitle("From Station").navigationBarItems(trailing:Button(action: {
             
                    self.appState.fromStationChooser = false
                
               
            }) {
                Text("Cancel").foregroundColor(Color("TextColor"))
            }).navigationBarTitleDisplayMode(.large)
        }.searchable(text: self.$searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct ClipStationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ClipStationSearchView(appState: AppClipState())
    }
}
