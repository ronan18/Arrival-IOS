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
            OnboardingScreen(image: "Location", title: "Low Data Usage", description: "Arrival harnesses modern technologies in order to receive schedules and make predictions without using excessive cellular data. As much processing is done on device as possible.", button: "CONTINUE", next: {self.screen = .lowData}, back: { self.screen = .welcome})
        } else if (self.screen == .lowData) {
            OnboardingScreen(image: "DataSync", title: "Anonymous", description: "Because you use Arrival during your daily commute, it has access to what BART stops you take and when. This information is stored securley on device and only used to make your commute easier. This information is never shared or sold.", button: "CONTINUE", next: { self.appState.requestLocation();self.screen = .anonymous}, back: {
                self.screen = .suggestions})
        } else if (self.screen == .anonymous) {
            OnboardingScreen(image: "Secure", title: "Smart Suggestions", description: "Arrival uses on device machine learning to understand your commute to allow you to access the information you need faster.", button: "GET STARTED", next: {
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
