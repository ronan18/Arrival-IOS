//
//  LowDataUsage.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct LowDataUsage: View {
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
                Button(action:back) {
                    Text("Back")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Spacer()
            Image("dataSync").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300)
            Text(config?.title ??  "Low Data Usage")
                .font(.largeTitle)
                .fontWeight(.bold).multilineTextAlignment(.center)
            Spacer().frame(height: 10)
            Text(config?.description ??  "Arrival harnesses modern technologies in order to receive schedules and make predictions witout using tons of cellular data") .multilineTextAlignment(.center)
                .font(.footnote)
            Spacer()
            StyledButton(action: next, text: "CONTINUE")
        }.padding()
    }
}

struct LowDataUsage_Previews: PreviewProvider {
    static var previews: some View {
        LowDataUsage(next:{},back: {})
    }
}
