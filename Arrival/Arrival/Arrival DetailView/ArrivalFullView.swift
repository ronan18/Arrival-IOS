//
//  ArrivalFullView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/11/23.
//

import SwiftUI
import ArrivalCore
import ArrivalGTFS

struct ArrivalFullView: View {
    @EnvironmentObject var appState: AppState
    var arrival: Arrival
    var body: some View {
        Group {
            switch arrival.type {
            case .train(let train):
                TrainArrivalFullView(train: train).environmentObject(appState)
            case .tripPlan(let plan):
               TripArrivalFullView(trip: plan).environmentObject(appState)
            }
        }
    }
}

/*struct ArrivalFullView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalFullView()
    }
}
*/

    

