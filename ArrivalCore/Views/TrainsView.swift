//
//  TrainsView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainsView: View {
    var trains: [Train]
    var body: some View {
        ScrollView {
                   Spacer().frame(height: 10)
            ForEach(trains) { train in
                TrainCard(train: train).padding(.horizontal)
            }
        }
    }
}

struct TrainsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainsView(trains: [])
    }
}
