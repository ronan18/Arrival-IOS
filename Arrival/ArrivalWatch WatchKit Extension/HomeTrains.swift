//
//  HomeTrains.swift
//  ArrivalWatch WatchKit Extension
//
//  Created by Ronan Furuta on 9/29/21.
//

import SwiftUI
import ArrivalWatchCore
import ArrivalWatchUI

struct HomeTrains: View {
    @ObservedObject var appState: WatchAppState
    @State var timeDisplayMode: TimeDisplayType = .timeTill
    var body: some View {
        List {
            ForEach(self.appState.trains) {train in
                TrainView(train: train, timeDisplayMode: self.$timeDisplayMode).listStyle(.plain).listRowInsets(EdgeInsets())
            }
            
        }.refreshable {
            await self.appState.cycle()
        }
    }
}

struct HomeTrains_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrains(appState: WatchAppState())
    }
}
