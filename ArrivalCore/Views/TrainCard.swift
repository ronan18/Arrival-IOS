//
//  TrainCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainCard: View {
    let direction: String
    let color: Color
    var cars: Int? = nil
    var departs: String
    var arrives: TimeDisplay?
    private let latterAlignment: HorizontalAlignment = .leading
    init(direction: String, color: TrainColor, cars: Int? = nil, departs: Date, arrives: Date? = nil) {
        self.direction = direction
        self.cars = cars
        self.color = converTrainColor(color)
        self.departs = String(displayMinutes(departs))
        if let arrives = arrives {
               self.arrives = displayTime(arrives)
        }
    
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
                        Text("min")
                            .font(.caption)
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
        
        TrainCard(direction: "Antioch", color: TrainColor.yellow, cars: 5, departs: Date() + TimeInterval(600),  arrives: Date(timeIntervalSinceNow: 1800))
        // TrainCard(direction: "Antioch", color: TrainColor.yellow, departs: Date(), arrives: Date())
        
        
    }
}
