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
    var config: OnBoardingConfig? = nil
    @State var screen: OnBoardingScreens = .welcome
    var body: some View {
        VStack {
            if (self.screen == .welcome) {
                Welcome(next: {self.screen = .lowData}, config: config?.welcome)
            } else if (self.screen == .lowData) {
                LowDataUsage(next: {self.screen = .smart}, back: {self.screen = .welcome}, config: config?.lowDataUsage)
            } else if (self.screen == .smart) {
                SmartSuggestions(next: {self.screen = .anonymous}, back: {self.screen = .lowData}, config: config?.smartDataSuggestions)
            } else {
                Anonymous(next: next, back: {self.screen = .smart}, config: config?.anonymous)
            }
            
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding(next: {})
    }
}
