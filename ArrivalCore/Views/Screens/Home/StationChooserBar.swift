//
//  StationChooser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationChooserBar: View {
    var fromStation: Station?  = nil
    var toStation: Station? = nil
    var leftAction: (()->())
    var centerAction: (()->())
    var rightAction: (()->())
    var skeleton: Bool = false
    var body: some View {
        HStack {
            StationChooserButton(title: "from", value: fromStation?.name,alignment: .leading, action: leftAction, skelton: skeleton)
            Spacer()
            StationChooserButton(title: "leave", value: "Now",alignment: .center, action: centerAction, skelton: skeleton)
            Spacer()
            StationChooserButton(title: "to", value: toStation?.name ?? "none",alignment: .trailing,action: rightAction, skelton: skeleton)
            
        }.padding().background(Color("blackBG")).foregroundColor(.white)
    }
}
struct StationChooserButton: View {
    var title: String
    var value: String?
    var alignment: HorizontalAlignment
    var action: (()->())
    var skelton: Bool = false
    var body: some View {
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
                        Text(value ?? "Choose")
                            .font(.headline)
                    }
                }
            }
        }
        
    }
}

struct StationChooser_Previews: PreviewProvider {
    static var previews: some View {
        StationChooserBar(leftAction: {print("left")}, centerAction: {print("center")}, rightAction: {print("right")})
    }
}
