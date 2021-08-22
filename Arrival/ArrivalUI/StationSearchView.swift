//
//  StationSearchView.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

struct StationSearchView: View {
    @State var searchText: String = ""
    var body: some View {
        NavigationView() {
            List() {
                StationCard().listRowSeparator(.hidden)
                StationCard().listRowSeparator(.hidden)
                StationCard().listRowSeparator(.hidden)
            }.listStyle(.plain).navigationBarTitle("To Station").navigationBarItems(trailing:Button(action: {}) {
                Text("Cancel")
            }).navigationBarTitleDisplayMode(.large)
        }.searchable(text: self.$searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct StationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationSearchView()
    }
}
