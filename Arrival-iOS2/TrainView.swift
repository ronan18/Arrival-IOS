//
//  TrainView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import SwiftyJSON
let sampleData = [1,2,3,4,5]
struct TrainView: View {
    @EnvironmentObject private var appData: AppData
    @State private var direction = 0
    @State private var showTransfers = false
    @State private var tripToShow: TripInfo = TripInfo(origin: "", destination: "", legs: [], originTime: "", destinatonTime: "", tripTIme: 0.0)
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
                    if (self.appData.toStation.abbr != "none") {
                        List(self.appData.trips) { trip in
                            
                            
                            Button(action: {
                                self.tripToShow = trip
                                self.showTransfers = true
                            }) {
                                TrainComponent(type: "train",  name: trip.destination, departs: trip.originTime, color: self.appData.convertColor(color: trip.legs[0].color), eta: trip.destinatonTime).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            
                            
                            
                        }.sheet(isPresented: $showTransfers) {
                            VStack {
                                HStack {
                                    Text("Trip Details")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    Button(action: {
                                        self.showTransfers = false
                                    }) {
                                        Text("Close")
                                    }
                                }
                                List(self.tripToShow.legs) {leg in
                                    HStack {
                                 
                                        Rectangle().frame(width: 10.0).foregroundColor(self.appData.convertColor(color: leg.color))
                                     
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .center) {
                                                VStack(alignment: .leading) {
                                                Text(leg.trainDestination).font(.headline) + Text(" train").font(.caption)
                                                    Text(leg.origin).font(.subheadline)
                                                }
                                                Spacer()
                                                 Text(leg.originTime).font(.subheadline)
                                            }.lineLimit(1)
                                            Spacer().frame(height: 15)
                                            HStack {
                                                Text("ride ").font(.caption) +
                                                Text(String(leg.stops)).font(.caption) +
                                                Text(" stops...").font(.caption)


                                            }
                                              Spacer().frame(height: 15)
                                            HStack(alignment: .center) {
                                               
                                                Text(leg.destination).font(.headline) + Text(" station").font(.caption)
                                                Spacer()
                                                Text(leg.destinationTime).font(.subheadline)
                                                
                                            }.lineLimit(1)
                                            
                                        }.padding()
                                    
                                    }.cornerRadius(10).background(Color.background).overlay(
                                        RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
                                    ).cornerRadius(10.0)
                                    
                                }
                                Spacer()
                                
                            }.padding()
                        }
                    } else {
                        List(self.appData.trains) { train in
                            
                            
                            
                            TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                        }
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
