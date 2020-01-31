//
//  StationChooserView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationChooserView: View {
    @EnvironmentObject private var appData: AppData
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Search for a Station", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            Text("suggested")
                .font(.caption)
            List(self.appData.closestStations) { station in
                Button(action: {
                    print("set from station", station)
                    self.appData.setFromStation(station: station)
                }) {
                    TrainComponent(type: "station", name: station.name)
                }
                
            }
            Spacer()
        }
    }
}

struct StationChooserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StationChooserView().environment(\.colorScheme, .dark).environmentObject(AppData())
            StationChooserView().environment(\.colorScheme, .light).environmentObject(AppData())
        }
        
    }
}
