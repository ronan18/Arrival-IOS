//
//  TOS.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
public struct TOS: View {
    var config: termsOfServiceConfig
    public init(config: termsOfServiceConfig) {
        self.config = config
    }
    public  var body: some View {
        VStack {
            Text("By using Arrival, you agree to our")
            HStack {
                Button(action: {
                    Analytics.logEvent("privacyPolicy_clicked", parameters: [:])
                    UIApplication.shared.open(config.privacy)
                })  {
                    Text("Privacy Policy")
                }
                Button(action: {
                    Analytics.logEvent("termsOfService_clicked", parameters: [:])
                    UIApplication.shared.open(config.tos)
                })  {
                    Text("Terms of Service")
                }
            }
        }.font(.caption).multilineTextAlignment(.center)
    }
}

struct TOS_Previews: PreviewProvider {
    static var previews: some View {
        TOS(config: termsOfServiceConfig(tos: URL(string: "https://arrival.city/termsofservice.html")!, privacy:  URL(string: "https://arrival.city/privacypolicy.html")!))
    }
}
