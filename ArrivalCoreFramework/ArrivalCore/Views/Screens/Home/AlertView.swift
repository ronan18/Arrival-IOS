//
//  AlertView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
public struct AlertView: View {
    let id: String
    let text: String
    var link: URL? = nil
    var close: (()->())
    public init(id: String, text: String, link: URL? = nil, close: @escaping (()->())) {
        self.id = id
        self.text = text
        self.link = link
    self.close = close
    }
    public var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text(text).multilineTextAlignment(.center).foregroundColor(.white).lineLimit(.none)
                Spacer()
            }
            HStack(alignment: .center) {
                Button(action: {
                    if let url = self.link {
                        Analytics.logEvent("appMessageHidden", parameters: ["link": self.id])
                      close()
                    }
                }) {
                    Text("dismiss").fontWeight(.regular).padding([.top, .horizontal]).foregroundColor(.white)
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
         
            }
            
            
        }.padding().background(Color("darkGrey")).font(.callout)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(id: "test",text: "California is under a mandatory shelter at home order during the Covid-19 pandemic. All non-essential travel should be avoided. BART is operating under a modified schedule and closes at 9pm. Weekday trains run every 30 minutes. Face coverings are required.", close: {})
    }
}
