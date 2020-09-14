//
//  LocationAccessRequest.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public struct PleaseChooseFromStation: View {
    var locationAlert = false
    var clicked: (()->())
    public init(locationAlert: Bool = false, clicked: @escaping (()->())) {
        self.locationAlert = locationAlert
        self.clicked = clicked
    }
    public var body: some View {
        VStack {
            Spacer()
            Button(action: clicked) {
                Text("Please choose a departure station")
            }.padding()
            if (locationAlert) {
            Text("Enable location services to automatically determine your closest station.").font(.subheadline)
                Text("(location data is never stored or shared)")
                    .font(.caption).padding(5)
            }
            Spacer()
            }.padding().multilineTextAlignment(.center)
    }
}

struct LocationAccessRequest_Previews: PreviewProvider {
    static var previews: some View {
        PleaseChooseFromStation(clicked: {})
    }
}
