//
//  StationView.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/9/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationView: View {
    @EnvironmentObject var userData: UserData
   
    var onDismiss: () -> ()
   
           
    
    var body: some View {
       
        VStack{
           
            HStack(alignment: .center) {
                Text("Choose Station")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { self.onDismiss() }) {
                    Text("Dismiss")
                }
            }
            //TODO use a search feild
            TextField("Seach for station", text: $userData.fromStationSearch)
            List(userData.stations.filter{
                if userData.fromStationSearch.count > 0 {
                   return  $0.name.contains(userData.fromStationSearch)
                } else {
                    return true
                }
                
            }) {  station  in
                Button(action: {
                    print("chose " + station.name)
                    self.onDismiss()
                }) {
                      Text(station.name)
                }
               
              
                
            }
            Spacer()
            
        }.padding()
        
    }
}
