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
                 Image(systemName: "checkmark.circle.fill")
                 Text("Arrive \(time)!")
            } else {
                Image(systemName: "clock.fill")
                if (type == "transfer") {
                    Text("Wait \(time) to Transfer")
                } else if (type == "board") {
                     Text("Wait \(time) to Board")
                } else {
                    Text("Wait \(time)")
                }
            }
           
            Spacer()
        }.foregroundColor(.black)
    }
}

struct TripWaitTimeView_Previews: PreviewProvider {
    static var previews: some View {
        TripWaitTimeView()
    }
}
