//
//  TrainCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainCard: View {
    var direction: String
    var color: Color
    var cars: Int? = nil
    var departs: String
    var arrives: TimeDisplay?
    var hideUnit: Bool = false
    private let latterAlignment: HorizontalAlignment = .leading
    init(train: Train? = nil, trip: Trip? = nil) {
        if let train = train {
            self.direction = train.destinationStation.name
            self.cars = train.cars
            self.color = converTrainColor(train.color)
            let departTime = displayMinutes(train.etd)
            if departTime < 1 {
                self.departs = "now"
                self.hideUnit = true
            } else {
                self.departs = String(departTime)
            }
        } else if let trip = trip  {
            self.direction = trip.legs[0].trainHeadSTN
            self.color = converTrainColor(trip.legs[0].route.color)
            let departTime = displayMinutes(trip.originTime)
            if departTime < 1 {
                self.departs = "now"
                self.hideUnit = true
            } else {
                self.departs = String(departTime)
            }
            
            self.arrives = displayTime(trip.legs[0].destinationTime)
        } else {
            self.direction = ""
            self.color = .yellow
            self.departs = "now"
        }
        
        /* if let arrives = arrives {
         self.arrives = displayTime(arrives)
         }*/
        
    }
    var body: some View {
        HStack(){
            Rectangle()
                .frame(width: 10.0)
                .foregroundColor(self.color)
            HStack(alignment: .lastTextBaseline) {
                VStack (alignment: .leading) {
                    Text("direction")
                        .font(.caption)
                    Text(direction)
                        .font(.headline)
                }
                Spacer()
                if (self.cars != nil) {
                    VStack (alignment: latterAlignment) {
                        Text("cars")
                            .font(.caption)
                        Text(String(cars ?? 0))
                            .font(.headline)
                    }
                }
                VStack (alignment: latterAlignment) {
                    Text("departs")
                        .font(.caption)
                    HStack(alignment: .lastTextBaseline,spacing: 0) {
                        Text(self.departs)
                            .font(.headline)
                        if(!self.hideUnit) {
                            Text("min")
                                .font(.caption)
                        }
                        
                    }
                    
                }
                if (self.arrives != nil) {
                    VStack (alignment: latterAlignment) {
                        Text("arrives")
                            .font(.caption)
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text(self.arrives?.time ?? "")
                                .font(.headline)
                            Text(self.arrives?.a ?? "")
                                .font(.caption)
                        }
                    }
                }
            }.padding([.vertical,.trailing])
        }.frame(height: 60.0).cornerRadius(10).background(Color("cardBackground")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TrainCard_Previews: PreviewProvider {
    static var previews: some View {
        
        TrainCard(train: Train(departureStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), destinationStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), etd: Date(), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red,  cars: 10))
        // TrainCard(direction: "Antioch", color: TrainColor.yellow, departs: Date(), arrives: Date())
        
        
    }
}
