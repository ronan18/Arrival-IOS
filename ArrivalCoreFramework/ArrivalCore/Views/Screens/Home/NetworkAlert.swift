//
//  NetworkAlert.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public struct NetworkAlert: View {
    public var body: some View {
        HStack {
            Spacer()
            Text("NO NETWORK").font(.headline).fontWeight(.bold).foregroundColor(.white)
            Spacer()
        }.padding().background(Color.red)
    }
}

struct NetworkAlert_Previews: PreviewProvider {
    static var previews: some View {
        NetworkAlert()
    }
}
