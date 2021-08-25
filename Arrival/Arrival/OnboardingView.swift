//
//  OnboardingView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/24/21.
//

import SwiftUI
import ArrivalCore
import ArrivalUI
struct OnboardingView: View {
    private enum OnboardingScreens {
        case welcome
        case suggestions
        case lowData
        case anonymous
    }
    @State private var screen: OnboardingScreens = .welcome
    var body: some View {
        if self.screen == .welcome {
            OnboardingIntro(next: {self.screen = .suggestions})
            
        } else if (self.screen == .suggestions) {
            OnboardingScreen(image: "Location", title: "Smart Suggestions", description: "Arrival uses your location to determine te closest BART station and automatically show realtime predictions. (We never store or share your location)", button: "CONTINUE", next: {self.screen = .lowData}, back: { self.screen = .welcome})
        } else if (self.screen == .lowData) {
            OnboardingScreen(image: "DataSync", title: "Smart Suggestions", description: "Arrival uses your location to determine te closest BART station and automatically show realtime predictions. (We never store or share your location)", button: "CONTINUE", next: {self.screen = .anonymous}, back: {self.screen = .suggestions})
        } else if (self.screen == .anonymous) {
            OnboardingScreen(image: "Secure", title: "Smart Suggestions", description: "Arrival uses your location to determine te closest BART station and automatically show realtime predictions. (We never store or share your location)", button: "CONTINUE", next: {}, back: {self.screen = .lowData})
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
