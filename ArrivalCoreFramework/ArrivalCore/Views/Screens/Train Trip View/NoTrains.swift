//
//  NoTrains.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct NoTrains: View {
    var body: some View {
        VStack {
                Spacer()
               
                    Text("No Trains").padding()
              
                Spacer()
                }.padding().multilineTextAlignment(.center)
        }
    
}

struct NoTrains_Previews: PreviewProvider {
    static var previews: some View {
        NoTrains()
    }
}
