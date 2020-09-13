//
//  TrainCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainCard: View {
    var direction: String = "Rockridge"
    var color: Color = .red
    var cars: Int? = nil
    var departs: TimeDisplay = TimeDisplay(time: "", a: "")
    var arrives: TimeDisplay? = nil
    var hideUnit: Bool = false
    private let latterAlignment: HorizontalAlignment = .leading
    init(train: Train? = nil, trip: Trip? = nil) {
        if let train = train {
            self.direction = train.destinationStation.name
            self.cars = train.cars
            self.color = converTrainColor(train.color)
            let departTime = displayMinutesString(train.etd)
            if departTime.time == "now" {
                
                self.hideUnit = true
            }
            self.departs = departTime
            print("DISPLAY TIME:", self.departs)
        } else if let trip = trip  {
            self.direction = trip.legs[0].trainHeadSTN
            self.color = converTrainColor(trip.legs[0].route.color)
            let departTime = displayMinutesString(trip.originTime)
            if departTime.time == "now" {
               
                self.hideUnit = true
            }
            self.departs = departTime
                      print("DISPLAY TIME:", self.departs)
            self.arrives = displayTime(trip.legs[0].destinationTime)
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
                        Text(self.departs.time)
                            .font(.headline)
                        if(!self.hideUnit) {
                            Text(self.departs.a)
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
        Group {
             TrainCard(train: Train(departureStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), destinationStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), etd: Date(timeIntervalSinceNow: 0), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red,  cars: 10)).previewLayout(PreviewLayout.sizeThatFits)
             .padding()
        TrainCard(train: Train(departureStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), destinationStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), etd: Date(timeIntervalSinceNow: 60*3), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red,  cars: 10)).previewLayout(PreviewLayout.sizeThatFits)
        .padding()
            TrainCard(train: Train(departureStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), destinationStation: Station(id: "abbr", name: "Rockridge", abbr: "test"), etd: Date(timeIntervalSinceNow: 60*45), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red,  cars: 10)).previewLayout(PreviewLayout.sizeThatFits)
            .padding()
        }
        // TrainCard(direction: "Antioch", color: TrainColor.yellow, departs: Date(), arrives: Date())
        
        
    }
}
