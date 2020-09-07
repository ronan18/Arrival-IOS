//
//  TOS.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TOS: View {
    var body: some View {
        VStack {
            Text("By using Arrival, you agree to our")
            HStack {
                Button(action: {})  {
                    Text("Privacy Policy")
                }
                Button(action: {})  {
                    Text("Terms of Service")
                }
            }
        }.font(.caption).multilineTextAlignment(.center)
    }
}

struct TOS_Previews: PreviewProvider {
    static var previews: some View {
        TOS()
    }
}
