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
            DispatchQueue.global(qos: .utility).async {

            let stations =  api.getStations()
                DispatchQueue.main.async {
                      print("post stations", stations)
                }
            }
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
