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
    @State private var direction = 0
   
    var body: some View {
        VStack {
            if (self.appData.noTrains) {
                Spacer()
                Text("No Trains")
                Spacer()
            } else if (self.appData.trains.isEmpty || !self.appData.loaded) {
                
                List {
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                }
                
                
                
                
            } else {
                if (self.appData.sortTrainsByTime || self.appData.toStation.abbr != "none") {
                    
                    List(self.appData.trains) { train in
                        
                        
                        TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                    }
                } else {
                    
                    Picker("",selection: self.$direction) {
                        Text("Northbound").tag(0)
                        Text("Southbound").tag(1)
                        
                    }.pickerStyle(SegmentedPickerStyle()).padding([.top, .leading, .trailing])
                    List {
                        if (self.direction == 0) {
                            ForEach(self.appData.northTrains) { train in
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta)
                                
                            }
                            
                        } else {
                            ForEach(self.appData.southTrains) { train in
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta)
                            }
                        }
                    }
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
