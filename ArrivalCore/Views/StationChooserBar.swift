//
//  StationChooser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct StationChooserBar: View {
     var leftAction: (()->())
    var centerAction: (()->())
    var rightAction: (()->())
    var body: some View {
        HStack {
            StationChooserButton(title: "depart", value: "Rockridge",alignment: .leading, action: leftAction)
            Spacer()
            StationChooserButton(title: "leave", value: "Now",alignment: .center, action: centerAction)
            Spacer()
            StationChooserButton(title: "arrive", value: "Balboa Park",alignment: .trailing,action: rightAction)
            
        }.padding().background(Color("darkGrey")).foregroundColor(.white)
    }
}
struct StationChooserButton: View {
    var title: String
    var value: String
    var alignment: HorizontalAlignment
    var action: (()->())
    var body: some View {
        Button(action: action) {
            VStack(alignment: alignment) {
                Text(title)
                    .font(.caption)
                Text(value)
                    .font(.headline)
            }
        }
        
    }
}

struct StationChooser_Previews: PreviewProvider {
    static var previews: some View {
       StationChooserBar(leftAction: {print("left")}, centerAction: {print("center")}, rightAction: {print("right")})
    }
}
