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
    @ObservedObject var appState: AppState
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
            OnboardingScreen(image: "Location", title: "Low Data Usage", description: "Arrival harnesses modern technologies in order to receive schedules and make predictions without using tons of cellular data.", button: "CONTINUE", next: {self.screen = .lowData}, back: { self.screen = .welcome})
        } else if (self.screen == .lowData) {
            OnboardingScreen(image: "DataSync", title: "Anonymous", description: "Arrival harnesses modern technologies in order to receive schedules and make predictions without using tons of cellular data.", button: "CONTINUE", next: { self.appState.requestLocation();self.screen = .anonymous}, back: {
                self.screen = .suggestions})
        } else if (self.screen == .anonymous) {
            OnboardingScreen(image: "Secure", title: "Smart Suggestions", description: "Because Arrival collects some pretty personal information, your daily commute, your data is stored on device.", button: "GET STARTED", next: {
                Task {
                   
                       await self.appState.createAccount()
                
                }
            }, back: {self.screen = .lowData})
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(appState: AppState())
    }
}
