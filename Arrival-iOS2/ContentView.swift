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
            print("pre stations")
            var stations: [Station]
           api.getStations(handleComplete: { stationList in
                print(stationList)

            })
               
      
          print("post stations not in async")
           /* api.login(key: "test", handleComplete: {
                api.getTrainsFrom(from: "ROCK", type: "now", time: "now")
            })*/
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
