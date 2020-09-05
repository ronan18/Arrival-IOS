//
//  ContentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Combine
import NotificationCenter

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("welcome")
            
            
        }.onAppear() {
            let api = ApiService()
           // print("pre stations")
            var stations: [Station] = []
           api.getStations(handleComplete: { stationList in
           //     print(stationList)
            stations = stationList

            })
               
      
         // print("post stations not in async")
            api.login(key: "test", handleComplete: { authorized in
                if (authorized) {
                    print("logged in")
                    api.getTrainsFrom(from: Station(id: "asd", name: "Rockridge", abbr: "ROCK", lat: 123.2, long: 123.2), type: "now", time: "now", handleComplete: {result in
                        print("done trains")
                    })
                    api.getTrip(byID: "57926122-1284-4ebf-894d-75e1843f0181", handleComplete: { route in
                        print(route, "route")
                        
                    })
                } else {
                    print("logged out")
                }
               
            })
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
