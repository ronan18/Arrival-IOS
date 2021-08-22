//
//  HomeScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import ArrivalUI
struct HomeScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            ArrivalHeader()
            DestinationBar()
            HeaderAlert()
            HomeTrains()
            Spacer()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


