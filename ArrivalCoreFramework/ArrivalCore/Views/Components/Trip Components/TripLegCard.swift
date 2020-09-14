//
//  TripDetailCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI

public struct TripLegCard: View {
    var leg: TripLeg
    
    var transferText = "transfer..."
    var enrouteTime: TimeDisplay
    var originTime: TimeDisplay
    var destTime: TimeDisplay
    var stopsUntil:String = "stops until"
    public init(leg: TripLeg) {
        self.leg = leg
    
        if (leg.finalLeg) {
            self.transferText = "destination..."
        }
        if (leg.stopCount == 1) {
            self.stopsUntil = "stop until"
        }
        self.enrouteTime = displayTimeInterval(leg.enrouteTime)
        self.originTime = displayTime(leg.originTime)
        self.destTime = displayTime(leg.destinationTime)
    }
    public var body: some View {
        HStack(){
            Rectangle()
                .frame(width: 10.0)
                .foregroundColor(converTrainColor(self.leg.route.color))
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text(leg.origin)
                            .font(.headline).lineLimit(1)
                        HStack(spacing: 3) {
                            Image(systemName: "arrow.right.circle.fill")
                            Text(leg.trainHeadSTN).lineLimit(1)
                        }.font(.subheadline)
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(originTime.time)
                        Text(originTime.a).font(.caption)
                    }
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text("\(leg.stopCount) \(stopsUntil) \(transferText)").font(.footnote)
                        
                        
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(enrouteTime.time).font(.footnote)
                        Text(enrouteTime.a).font(.caption)
                    }
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text(self.leg.destination).lineLimit(1)
                            .font(.headline)
                        
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(destTime.time)
                        Text(destTime.a).font(.caption)
                    }
                }
            }.padding([.vertical,.trailing])
        }.frame(height: 150.0).cornerRadius(10).background(Color("cardBackground")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TripLegCard_Previews: PreviewProvider {
    static var previews: some View {
        TripLegCard(leg: MockData().trips[0].legs[0])
    }
}
