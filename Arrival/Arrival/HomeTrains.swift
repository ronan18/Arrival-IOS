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
    func filterTrains (_ trains: [Train]) -> [Train] {
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
            List() {
                ForEach(filterTrains(self.appState.trains)) {train in
                    TrainCard(train: train, timeDisplayMode: .init(get: {return self.appState.timeDisplayMode}, set: {self.appState.timeDisplayMode = $0})).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                }.edgesIgnoringSafeArea(.bottom)
                
            }.listStyle(.plain).refreshable {
                async {
                    await self.appState.cycle()
                }
            }.edgesIgnoringSafeArea(.bottom)
        }.padding().edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeTrains_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrains(appState: AppState())
    }
}
