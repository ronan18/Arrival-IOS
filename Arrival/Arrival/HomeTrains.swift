//
//  HomeTrains.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import Foundation
import SwiftUI
import ArrivalUI

struct HomeTrains: View {
    @ObservedObject var appState: AppState
    var body: some View {
        VStack {
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                Text("Northbound").tag(1)
                Text("Southbound").tag(2)
                Text("All").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            List() {
                ForEach(self.appState.trains) {train in
                    TrainCard(color: .yellow).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                }
                
            }.listStyle(.plain).refreshable {
                async {
                    await self.appState.cycle()
                }
            }
        }.padding()
    }
}

struct HomeTrains_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrains(appState: AppState())
    }
}
