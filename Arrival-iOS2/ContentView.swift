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
    @State var loaded = false
    var body: some View {
        VStack {
            if (!loaded) {
         Loading()
            } else {
                VStack(spacing: 0) {
                    HomeScreen()
                }
            }
            
            
        }.onAppear() {
          //  self.loaded = false
            let api = ApiService()
           // print("pre stations")
            var stations: StationStorage?
           api.getStations(handleComplete: { stationList in
             //   print(stationList)
            print("done stations")
            stations = stationList

            })
               
      
         // print("post stations not in async")
            api.login(key: "test", handleComplete: { authorized in
                if (authorized) {
                    print("logged in")
                    api.getTrainsFrom(from: Station(id: "asd", name: "Rockridge", abbr: "ROCK", lat: 123.2, long: 123.2), type: "now", time: "now", handleComplete: {result in
                        print("done trains")
                    })
                    api.getTrip(byID: "9ecf8fdc-1422-48b3-8dd6-efb2a25a59f6", handleComplete: { route in
                        print("done trip by ID")
                        
                    })
                    api.getTrips(from: Station(id: "WARM", name: "WARM", abbr: "WARM"), to: Station(id: "BALB", name: "ANTC", abbr: "ANTC"), type: "now", time: "now", handleComplete: {trips in
                        print("done trips from")
                        self.loaded = true
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
