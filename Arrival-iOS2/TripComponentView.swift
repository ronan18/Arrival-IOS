//
//  TripComponentView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TripComponentView: View {
    var fromStationName = "From Station"
    var trainName = "Train Name"
    var stops = 0
    var type = ""
    var destinationStationName = "Destination Station Name"
    var fromStationTime = "12:00pm"
    var toStationTime = "12:30pm"
    var enrouteTime = "30min"
    var color = Color.gray
    var body: some View {
        
        VStack {
            HStack {
                Rectangle().frame(width: 8.0).foregroundColor(color)
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(fromStationName)
                                .fontWeight(.semibold)
                            HStack(spacing: 0) {
                                Image(systemName: "arrow.right.circle.fill").font(.subheadline)
                                Spacer()
                                    .frame(width: 3.0)
                                Text(trainName).font(.subheadline)
                                
                            }
                            
                            
                            
                        }
                        Spacer()
                        Text(fromStationTime)
                            .font(.subheadline)
                    }
                    HStack {
                        if (type == "destination") {
                            Text("\(String(stops)) stops untill destination...")
                                                       .font(.caption).padding([.top, .bottom, .trailing])
                        
                        } else {
                            Text("\(String(stops)) stops untill transfer...")
                                                       .font(.caption).padding([.top, .bottom, .trailing])
                        }
                       
                        Spacer()
                        Text(enrouteTime)
                            .font(.caption)
                        
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(destinationStationName)  .fontWeight(.semibold)
                            
                            
                            
                            
                        }
                        Spacer()
                        Text(toStationTime)
                            .font(.subheadline)
                    }
                }.padding([.top, .bottom, .trailing]).padding(.leading, 5.0)
            }
        }.cornerRadius(10).background(Color.background).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0)
        
        
    }
}

struct TripComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TripComponentView()
    }
}
