//
//  ContentView.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import CoreLocation
let manager = CLLocationManager()

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    
    let baseAPI = "https://api.arrival.city"
    let stationAPI = "https://api.arrival.city/api/v2/stationlist"
    
    
    var body: some View {
        NavigationView {
            if userData.network && userData.trains.count > 0 {
                List(userData.trains) { Train in
                    HStack {
                        Text(Train.direction).font(.headline)
                        Spacer()
                        Text(String(Train.time) + Train.unit).font(.subheadline)
                    }
                    
                }.navigationBarTitle(Text(String(userData.closestStation.name)))
            } else {
                VStack {
                    Text("Network Error")
                }.navigationBarTitle(Text("Network Error"))
            }
        }
        
        
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
