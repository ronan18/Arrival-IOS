//
//  HomeTrains.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import Foundation
import SwiftUI
import ArrivalUI
import ArrivalCore
struct HomeTrains: View {
    @ObservedObject var appState: AppState
    @State var timeDisplayMode = TimeDisplayType.timeTill
    @State var filteredTrains: [Train] = []
    func filterTrains (_ trains: [Train], direction: TrainDirection? = nil) -> [Train] {
        
        return trains.filter({a in
            switch self.appState.directionFilter {
            case 1 :
                return a.direction == .north
            case 2:
                return a.direction == .south
            default:
                return true
            }
        })
    }
    var body: some View {
        VStack {
            Picker(selection: .init(get: {self.appState.directionFilter}, set: {self.appState.directionFilter = $0}), label: Text("Train Direction")) {
                Text("Northbound").tag(1)
                Text("Southbound").tag(2)
                Text("All").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
            if (filteredTrains.count > 0) {
            List() {
                ForEach(filteredTrains) {train in
                    TrainCard(train: train, timeDisplayMode: self.$timeDisplayMode).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                }.edgesIgnoringSafeArea(.bottom)
                
            }.listStyle(.plain).refreshable {
                Task {
                    await self.appState.cycle()
                }
            }.edgesIgnoringSafeArea(.bottom)
            } else {
                VStack {
                    Spacer()
                    Text("No Trains in this direction")
                    Spacer()
                }
            }
        }.padding().edgesIgnoringSafeArea(.bottom).onChange(of: self.appState.trains, perform: { trains in
            self.filteredTrains = self.filterTrains(trains)
        }).onChange(of: self.appState.directionFilter, perform: { direction in
            self.filteredTrains = self.filterTrains(self.appState.trains)
        })
    }
}

struct HomeTrains_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrains(appState: AppState())
    }
}
