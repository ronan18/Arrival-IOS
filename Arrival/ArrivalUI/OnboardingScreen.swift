//
//  OnboardingScreen.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/24/21.
//

import SwiftUI

public struct OnboardingScreen: View {
    let image: String
    let title: String
    let description: String
    let button: String
    let next: ()->()
    let back: ()->()
    public init (image: String, title: String, description: String, button: String = "CONTINUE", next: @escaping ()->(), back: @escaping ()->()) {
        self.image = image
        self.title = title
        self.description = description
        self.button = button
        self.next = next
        self.back = back
    }
   public var body: some View {
        VStack {
            HStack {
                Button(action: {back()}) {
                    Text("BACK").fontWeight(.bold)
                }
                Spacer()
            }
            Spacer().frame(height: 50)
            Image(image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300, maxHeight: 300).padding(.bottom)
            Text(title).font(.largeTitle).fontWeight(.bold)
            Text(description).font(.body).padding(.top, 1)
            Spacer()
            LargeButton(button, action: {next()}, haptic: true)
        }.padding([.top, .leading, .trailing]).multilineTextAlignment(.center)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(image: "Location", title: "Smart Suggestions", description: "Arrival uses your location to determine te closest BART station and automatically show realtime predictions. (We never store or share your location)", button: "CONTINUE", next: {}, back: {})
    }
}
