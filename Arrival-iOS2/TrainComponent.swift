//
//  TrainComponent.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/13/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainComponent: View {
    var type: String = "skeleton"
    var name: String = ""
    var cars: Int = 0
    var departs: String = ""
    var unit: String = ""
    var color: Color = Color.gray
    var eta: String = ""
    
    var body: some View {
        
        HStack {
            
            if (type == "train"  && color != Color.white) {
                Rectangle()
                    .frame(width: 10.0)
                    .foregroundColor(color)
            } else if (type == "trip"  && color != Color.white) {
                Rectangle()
                    .frame(width: 10.0)
                    .foregroundColor(color)
            }
            HStack {
                VStack(alignment: .leading) {
                    if (type != "skeleton") {
                    if (type == "train") { Text("direction").font(.caption)
                    }
                    Text(name).font(.headline)
                    } else {
                         Rectangle()
                                       .fill(Color.skeleton)
                                       .frame(width: 200, height: 15)
                    }
                }
                Spacer()
                if (type == "train") {
                    if (cars > 0) {
                        VStack(alignment: .trailing) {
                            Text("cars").font(.caption)
                            Text(String(cars)).font(.headline)
                        }
                    }
                    
                    
                    
                    VStack(alignment: .trailing) {
                        Text("departs").font(.caption)
                        
                        if  (String(departs) != "Leaving") {
                            if (unit.isEmpty) {
                                Text(String(departs)).font(.headline).font(.subheadline)
                            } else {
                               Text(String(departs)).font(.headline) +  Text(" " + unit).font(.subheadline)
                            }
                           
                            
                        } else {
                            Text(String("now")).font(.headline)
                        }
                        
                    }
                    if (!eta.isEmpty) {
                        VStack(alignment: .trailing) {
                            Text("arrives").font(.caption)
                            Text(String(eta)).font(.headline)
                        }
                    }
                    
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
            TrainComponent(type: "train", name:"Antioch", cars: 10, departs: "5", unit: "min", color: Color.yellow)
            TrainComponent(type: "station", name: "Antioch")
            TrainComponent(type: "skeleton")
        }
        
    }
}
