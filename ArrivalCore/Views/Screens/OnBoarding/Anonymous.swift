//
//  Anonymous.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct Anonymous: View {
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
                   Image("secure").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300)
                   Text("Anonymous")
                       .font(.largeTitle)
                       .fontWeight(.bold).multilineTextAlignment(.center)
                   Spacer().frame(height: 10)
                   Text("Because Arrival collects some pretty personal information, your daily commute, youe data is stored on device.") .multilineTextAlignment(.center)
                       .font(.footnote)
                   Spacer()
            TOS().padding()
                   StyledButton(action: next, text: "START NOW")
               }.padding()
    }
}

struct Anonymous_Previews: PreviewProvider {
    static var previews: some View {
        Anonymous(next: {}, back: {})
    }
}
