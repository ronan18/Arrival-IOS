//
//  Welcome.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct Welcome: View {
    var next: (()->())
    var config: OnBoardingScreenConfig? = nil
    public init(next: @escaping (()->()), config: OnBoardingScreenConfig? = nil) {
        self.next = next
        self.config = config
    }
   public var body: some View {
        VStack {
            Spacer()
            Image("map").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300)
            Text(config?.title ?? "Welcome to Arrival")
                .font(.largeTitle)
                .fontWeight(.bold) .multilineTextAlignment(.center)
            Text(config?.description ?? "The BART app for commuters")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Spacer()
            StyledButton(action: next, text: "CONTINUE")
        }.padding()
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(next: {})
    }
}
