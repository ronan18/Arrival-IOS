//
//  StationChooser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public func timeModeText(_ timeMode: TripTimeModel) -> String {
    switch timeMode.timeMode {
    case .now:
        return "Now"
    case .leave:
        return "Leave"
    case .arrive:
        return "Arrive"
    }
}

public struct StationChooserBar: View {
    var fromStation: Station?  = nil
    var toStation: Station? = nil
    var timeMode: TripTimeModel = TripTimeModel(timeMode: .now, time: Date())
    var leftAction: (()->())
    var centerAction: (()->())
    var rightAction: (()->())
    var skeleton: Bool = false
    var geometry: GeometryProxy
    public init(fromStation: Station? = nil, toStation: Station? = nil, timeMode: TripTimeModel = TripTimeModel(timeMode: .now, time: Date()), leftAction: @escaping (()->()), centerAction: @escaping (()->()), rightAction: @escaping (()->()), skeleton: Bool = false, geometry: GeometryProxy) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.timeMode = timeMode
        self.leftAction = leftAction
        self.centerAction = centerAction
        self.rightAction = rightAction
        self.skeleton = skeleton
        self.geometry = geometry
    }
    public var body: some View {
        
        HStack {
            HStack() {
               StationChooserButton(title: "from", value: self.fromStation?.name,alignment: .leading, action: self.leftAction, skelton: self.skeleton)
                Spacer()
            }.frame(maxWidth: (geometry.size.width / 3) - 5)
         
            
                Spacer()
                if (self.timeMode.timeMode == .now) {
                    StationChooserButton(title: "Leave", value: "Now",alignment: .center, action: self.centerAction, skelton: self.skeleton, disabled: self.fromStation == nil).multilineTextAlignment(.center)
                } else {
                    StationChooserButton(title: timeModeText(self.timeMode), value: displayTime(self.timeMode.time).time, unit: displayTime(self.timeMode.time).a,alignment: .center, action: self.centerAction, skelton: self.skeleton, disabled: self.fromStation == nil).multilineTextAlignment(.center)
                }
                
                Spacer()
            HStack {
                Spacer()
                StationChooserButton(title: "to", value: self.toStation?.name ?? "none",alignment: .trailing,action: self.rightAction, skelton: self.skeleton, disabled: self.fromStation == nil)
             }.frame(maxWidth: (geometry.size.width / 3) - 5)
            
        }.padding().background(Color("blackBG")).foregroundColor(.white)
        
        
    }
}
public struct StationChooserButton: View {
    var title: String
    var value: String?
    var unit: String? = nil
    var alignment: HorizontalAlignment
    var action: (()->())
    var skelton: Bool = false
    var disabled: Bool = false
    public init(title: String, value: String?,unit: String? = nil,alignment: HorizontalAlignment, action: @escaping (()->()), skelton: Bool = false, disabled: Bool = false) {
        self.title = title
        self.value = value
        self.unit = unit
        self.alignment = alignment
        self.action = action
        self.skelton = skelton
        self.disabled = disabled
    }
    public var body: some View {
        VStack {
            if (skelton) {
                VStack(alignment: alignment) {
                    Text(title)
                        .font(.caption).background(Color("skeleton"))
                    Spacer().frame(height:1)
                    Text("loading")
                        .font(.headline).background(Color("skeleton"))
                }.foregroundColor(Color("skeleton"))
            } else {
                Button(action: action) {
                    VStack(alignment: alignment) {
                        Text(title)
                            .font(.caption)
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text(value ?? "Choose")
                                .font(.headline).lineLimit(1)
                            if (self.unit != nil) {
                                Text(unit ?? "")
                                    .font(.caption)
                            }
                        }
                    }
                }.disabled(disabled).foregroundColor(disabled ? Color("skeleton") : Color.white)
            }
        }
        
    }
}

struct StationChooser_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            StationChooserBar(leftAction: {print("left")}, centerAction: {print("center")}, rightAction: {print("right")}, geometry: geometry)
        }
      
    }
}
