//
//  SmartSuggestions.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SmartSuggestions: View {
    var next: (()->())
        var back: (()->())
    var body: some View {
        VStack {
            HStack {
                Button(action: back) {
                    Text("Back")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Spacer()
            Image("location").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300, maxHeight: 200)
            Text("Smart Suggestions")
                .font(.largeTitle)
                .fontWeight(.bold).multilineTextAlignment(.center)
            Spacer().frame(height: 10)
            Text("Arrival users your location to determine te closest BART station and automatically show realtime predictions. (We never store or share your location)").multilineTextAlignment(.center)
                .font(.footnote)
            
            Spacer()
            StyledButton(action:next, text: "CONTINUE")
        }.padding()
    }
}

struct SmartSuggestions_Previews: PreviewProvider {
    static var previews: some View {
        SmartSuggestions(next: {}, back: {})
    }
}
