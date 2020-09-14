//
//  TrainsView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct TrainsView: View {
    @State var direction = 1
    var trains: [Train]
    var northTrains: [Train] = []
    var southTrains: [Train] = []
    var doubleMode = false
    public init(trains: [Train]) {
        self.trains = trains
        northTrains = trains.filter({$0.direction == .north})
        if (northTrains.count == 0) {
            doubleMode = true
        }
        southTrains = trains.filter({$0.direction == .south})
        if (southTrains.count == 0) {
            doubleMode = true
        }
    }
  public var body: some View {
        VStack {
            if (trains.count == 0) {
                NoTrains()
            } else {
            
            if (doubleMode) {
                ScrollView {
                    Spacer().frame(height: 10)
                    ForEach(trains) { train in
                        TrainCard(train: train).padding(.horizontal)
                    }
                }.edgesIgnoringSafeArea(.bottom)
            } else {
                Picker(selection: $direction, label: Text("Direction")) {
                    Text("Northbound").tag(1)
                    Text("Southbound").tag(2)
                }.pickerStyle(SegmentedPickerStyle()).padding([.leading, .trailing]).transition(.opacity).padding(.top)
                ScrollView {
                    Spacer().frame(height: 10)
                    if (direction == 1) {
                        ForEach(northTrains) { train in
                            TrainCard(train: train).padding(.horizontal)
                        }
                    } else {
                        ForEach(southTrains) { train in
                            TrainCard(train: train).padding(.horizontal)
                        }
                    }
                }.edgesIgnoringSafeArea(.bottom)
                
            }
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct TrainsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainsView(trains: [])
    }
}
