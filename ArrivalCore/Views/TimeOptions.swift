//
//  TimeOptions.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TimeOptions: View {
    var close: (() -> ())
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack() {
                Text("Time Options")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: close) {
                    Text("close")
                }
                
            }.padding([.horizontal, .top])
            
            
            VStack(alignment: .leading) {
                Divider()
                VStack(alignment: .leading) {
                    Text("Leave:")
                        .font(.subheadline)
                    HStack {
                        TimeOption(value: "now", selected: true)
                        Spacer()
                        TimeOption(value: "15", selected: false, unit: "min")
                        Spacer()
                        TimeOption(selected: false, type:.choose)
                    }.padding(.vertical)
                }.padding(.vertical)
                VStack(alignment: .leading) {
                    Text("Arrive:")
                        .font(.subheadline)
                    HStack {
                        
                        
                        TimeOption(value: "9:00", selected: false, unit: "am")
                        Spacer()
                        TimeOption(value: "10:00", selected: false, unit: "am")
                        Spacer()
                        TimeOption(value: "12:000", selected: false, unit: "pm")
                    }.padding(.vertical)
                    HStack {
                        TimeOption(value: "4:00", selected: false, unit: "pm")
                        Spacer()
                        TimeOption(value: "6:00", selected: false, unit: "pm")
                        Spacer()
                        TimeOption(value: "9:00", selected: true, unit: "pm", type:.choose)
                    }.padding(.vertical)
                }.padding(.vertical)
            }.padding()
            Spacer()
        }
    }
}

struct TimeOptions_Previews: PreviewProvider {
    static var previews: some View {
        TimeOptions(close: {print("close")})
    }
}

enum TimeOptionType {
    case preSet
    case choose
}

struct TimeOption: View {
    let value: String?
    var selected = false
    var unit: String? = nil
    var type: TimeOptionType = .preSet
    var borderWidth:CGFloat = 3
    var borderColor: Color
    init (value: String? = nil, selected: Bool, unit: String? = nil, type: TimeOptionType = .preSet) {
        self.value = value
        self.unit = unit
        self.type = type
        self.selected = selected
        switch type {
        case .choose:
            borderWidth = 6
        case .preSet:
            borderWidth = 4
        }
        if (selected) {
            borderColor = Color("arrivalBlue")
        } else {
            borderColor = Color(hex: "#CECECE")
        }
    }
    var body: some View {
        VStack {
            if (self.type == .choose) {
                HStack (alignment: .lastTextBaseline, spacing: 0) {
                    Text(value ?? "choose")
                        .font(.headline)
                    if (unit != nil) {
                        Text(unit ?? "")
                            .font(.caption)
                    }
                    
                }
                if (value != nil) {
                    Text("Tap to change")
                        .font(.caption)
                }
            } else {
                HStack (alignment: .lastTextBaseline, spacing: 0) {
                    Text(value ?? "")
                        .font(.headline)
                    if (unit != nil) {
                        Text(unit ?? "")
                            .font(.caption)
                    }
                    
                }
            }
        }.frame(width: 100, height: 100.0).cornerRadius(10).background(Color("cardBackground")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(borderColor, lineWidth:borderWidth)
        ).cornerRadius(10.0).padding(0)
    }
}
