//
//  AlertView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
struct AlertView: View {
    let text: String
    var link: URL? = nil
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text(text).multilineTextAlignment(.center).foregroundColor(.white)
                Spacer()
            }
            if (self.link != nil) {
                Button(action: {
                    if let url = self.link {
                        Analytics.logEvent("appMessageClicked", parameters: ["link": self.link])
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Learn More").fontWeight(.bold).padding([.top,.horizontal]).foregroundColor(Color("arrivalBlue"))
                }
            }
            
            
        }.padding().background(Color("darkGrey")).font(.callout)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(text: "California is under a mandatory shelter at home order during the Covid-19 pandemic. All non-essential travel should be avoided. BART is operating under a modified schedule and closes at 9pm. Weekday trains run every 30 minutes. Face coverings are required.")
    }
}
