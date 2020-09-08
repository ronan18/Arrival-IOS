//
//  TimeOption.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI



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
    var action: (() -> ())
    init (value: String? = nil, selected: Bool, unit: String? = nil, type: TimeOptionType = .preSet, action: @escaping (()-> ())) {
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
        self.action = action
    }
    var body: some View {
             Button (action: action) {
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
             }.foregroundColor(Color("Text"))
    }
}

struct TimeOption_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimeOption(value: "9:00", selected: true, unit: "pm", type:.choose, action: {print("tapped")}).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TimeOption(selected: false, type:.choose, action: {print("tapped")}).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TimeOption(value: "12:00", selected: false, unit: "pm", action: {print("tapped")}).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TimeOption(value: "now", selected: true, action: {print("tapped")}).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
            TimeOption(value: "now", selected: false, action: {print("tapped")}).previewLayout(PreviewLayout.sizeThatFits)
                .padding()
        }
        
    }}
