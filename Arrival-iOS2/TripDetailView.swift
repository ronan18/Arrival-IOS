//
//  TripDetailView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TripDetailView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Trip Details").font(.largeTitle).fontWeight(.bold)
                Spacer()
                Button(action: {}) {
                    Text("close")
                }
            }
            HStack {
                VStack {
                    Text("Departs")
                        .font(.caption)
                    Text("21:30")
                        .font(.headline)
                }
                VStack {
                    Divider()
                }
                Text("55") + Text(" min").font(.caption)
                VStack {
                    Divider()
                }
                VStack(alignment: .trailing) {
                    Text("Departs")
                        .font(.caption)
                    Text("21:30")
                        .font(.headline)
                }
                }.padding().cornerRadius(10).background(Color.background).overlay(
                RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
            ).cornerRadius(10.0)
            TripWaitTimeView(type: "board", time: "8min")
            
            Spacer()
        }.padding()
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView()
    }
}
