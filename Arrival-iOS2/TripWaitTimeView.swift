//
//  TripWaitTimeView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TripWaitTimeView: View {
  var type = ""
    var time = ""
    var body: some View {
        HStack {
            Spacer()
            if (type == "arrive") {
                 Image(systemName: "checkmark.circle")
                 Text("Arrive by \(time)!")
            } else {
                Image(systemName: "clock")
                if (type == "transfer") {
                    Text("\(time) transfer window")
                } else if (type == "board") {
                     Text("Board in \(time)")
                } else if (type == "boarded") {
                Text("Boarded")
                } else {
                    Text("Wait \(time)")
                }
            }
           
            Spacer()
        }.font(.subheadline)
    }
}

struct TripWaitTimeView_Previews: PreviewProvider {
    static var previews: some View {
        TripWaitTimeView()
    }
}
