//
//  TermsOfSeriviceView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/13/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAnalytics
struct TermsOfSeriviceView: View {
    @EnvironmentObject private var appData: AppData
    var body: some View {
        VStack {
            
            Text("By using Arrival you agree to our")
            HStack {
                Spacer()
                Button(action: {
                    Analytics.logEvent("privacy_policy_clicked", parameters: [
                        "auth": self.appData.auth as NSObject])
                    if let url = URL(string: self.appData.privacyPolicy) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Privacy Policy")
                }
                
                Button(action: {
                    Analytics.logEvent("terms_of_service_clicked", parameters: [
                    "auth": self.appData.auth as NSObject])
                    if let url = URL(string: self.appData.termsOfService) {
                        UIApplication.shared.open(url)
                    }
                    
                }) {
                    Text("Terms of Service")
                }
                Spacer()
            }
            
        }.font(.caption).padding()
        
    }
}

struct TermsOfSeriviceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfSeriviceView()
    }
}
