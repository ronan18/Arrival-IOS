//
//  OnBoarding.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
enum OnBoardingScreens {
    case welcome
    case lowData
    case smart
    case anonymous
}
struct OnBoarding: View {
    let next: (()->())
    @State var screen: OnBoardingScreens = .welcome
    var body: some View {
        VStack {
            if (self.screen == .welcome) {
                Welcome(next: {self.screen = .lowData})
            } else if (self.screen == .lowData) {
                LowDataUsage(next: {self.screen = .smart}, back: {self.screen = .welcome})
            } else if (self.screen == .smart) {
                SmartSuggestions(next: {self.screen = .anonymous}, back: {self.screen = .lowData})
            } else {
                Anonymous(next: next, back: {self.screen = .smart})
            }
            
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding(next: {})
    }
}
