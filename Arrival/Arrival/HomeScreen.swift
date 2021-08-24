//
//  HomeScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import Foundation
import Combine
import ArrivalUI
import ArrivalCore
struct HomeScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            ArrivalHeader()
            DestinationBar()
            HeaderAlert()
            HomeTrains()
            Spacer()
        }.task {
            let api = ArrivalAPI()
            print("Starting station get")
            if (await api.login(auth: "test")) {
                //await api.trip(byID: "test")
                var data: StationStorage? = nil
                
                data = await ArrivalAPI().stations()
                
                print("Got stations")
                print(data as Any)
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


