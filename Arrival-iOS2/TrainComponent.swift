//
//  TrainComponent.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/13/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainComponent: View {
    var type: String
    var name: String = ""
     var cars: Int = 0
    var departs: Int = 0
     var unit: String = ""
    var color: Color = Color.gray
    
    var body: some View {
        
            HStack {
                if (type == "train") {
                   Rectangle()
                       .frame(width: 10.0)
                       .foregroundColor(color)
                }
                   HStack {
                       VStack(alignment: .leading) {
                        if (type == "train") { Text("direction").font(.caption)
                        }
                           Text(name).font(.headline)
                       }
                       Spacer()
                     if (type == "train") {
                       VStack(alignment: .trailing) {
                           Text("cars").font(.caption)
                           Text(String(cars)).font(.headline)
                       }
                   
                       VStack(alignment: .trailing) {
                           Text("departs").font(.caption)
                           Text(String(departs)).font(.headline) + Text(" " + unit).font(.subheadline)
                       }
                  .padding(10.0).padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                    }
                }.padding()
                   
            }
            .frame(height: 60.0)
            .cornerRadius(10).background(Color.background).overlay(
                   RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
               ).cornerRadius(10.0)
    }
}

struct TrainComponent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrainComponent(type: "train", name:"Antioch", cars: 10, departs: 5, unit: "min", color: Color.yellow)
            TrainComponent(type: "station", name: "Antioch")
        }
   
    }
}
