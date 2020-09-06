//
//  StationCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationCard: View {
    let station: Station
    var body: some View {
           HStack(){
              
                HStack(alignment: .lastTextBaseline) {
                    Text(station.name)
                                              .font(.headline)
                    Spacer()
                }.padding()
            }.frame(height: 60.0).cornerRadius(10).background(Color("cardBackground")).overlay(
                RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
            ).cornerRadius(10.0).padding(0)
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(station: Station(id: "rock", name: "Rockridge", abbr: "ROCK"))
    }
}
