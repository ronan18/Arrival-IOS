//
//  TrainView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
let sampleData = [1,2,3,4,5]
struct TrainView: View {
    @EnvironmentObject private var appData: AppData
    init() {
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        VStack {
            if (self.appData.trains.isEmpty || !self.appData.loaded) {
                
                List {
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                }
                
                
                
                
            } else {
                List(self.appData.trains) { train in
                    
                    
                    TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }
            }
            
            
        }
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrainView().environment(\.colorScheme, .dark).environmentObject(AppData())
            TrainView().environment(\.colorScheme, .light).environmentObject(AppData())
        }
    }
}
