//
//  OnboardingIntro.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/24/21.
//

import SwiftUI

public struct OnboardingIntro: View {
    let next: ()->()
    public init(next: @escaping ()->()) {
        self.next = next
    }
    public var body: some View {
        VStack {
            Spacer().frame(height: 100)
            Image("Map").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300).padding(.bottom)
            Text("Welcome to Arrival").font(.largeTitle).fontWeight(.bold)
            Text("The BART app for commuters").font(.title2)
            Spacer()
            ArrivalLegal().padding(.bottom)
            LargeButton("CONTINUE", action: {next()}, haptic: true)
            
        }.padding([.top, .leading, .trailing]).multilineTextAlignment(.center)
    }
}

struct OnboardingIntro_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntro(next: {})
    }
}
