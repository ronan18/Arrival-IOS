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
      var config: OnBoardingScreenConfig? = nil
    public init(next: @escaping (()->()), back: @escaping (()->()), config: OnBoardingScreenConfig? = nil) {
        self.next = next
        self.back = back
        self.config = config
    }
   public var body: some View {
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
                   Text(config?.title ??  "Anonymous")
                       .font(.largeTitle)
                       .fontWeight(.bold).multilineTextAlignment(.center)
                   Spacer().frame(height: 10)
                   Text(config?.description ?? "Because Arrival collects some pretty personal information, your daily commute, your data is stored on device.") .multilineTextAlignment(.center)
                       .font(.footnote)
                   Spacer()
            TOS(config: self.config!.tosConfig).padding()
                   StyledButton(action: next, text: "START NOW")
               }.padding()
    }
}

struct Anonymous_Previews: PreviewProvider {
    static var previews: some View {
        Anonymous(next: {}, back: {})
    }
}
