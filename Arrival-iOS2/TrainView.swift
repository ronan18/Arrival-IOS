//
//  TrainView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import FirebaseAnalytics
import FirebaseCrashlytics

let sampleData = [1,2,3,4,5]
struct TrainView: View {
    @EnvironmentObject private var appData: AppData
    @State private var direction = 0
    @State private var showTransfers = false
    @State private var tripToShow: TripInfo = TripInfo(origin: "", destination: "", legs: [], originTime: "", originDate: "", destinatonTime: "", destinatonDate: "", tripTIme: 0.0, leavesIn: 5, tripId: "test")
    var body: some View {
        VStack {
            if (self.appData.noTrains) {
                Spacer()
                Text("No Trains")
                Spacer()
            } else if (self.appData.trains.isEmpty || !self.appData.loaded) {
                
                List {
                    if (self.appData.reviewCard) {
                        NotificationCard(type: "review").padding([.top, .leading, .trailing]).padding([.bottom, .top], 3).environmentObject(self.appData).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                    TrainComponent(type: "skeleton")
                }
                
                
                
                
            } else {
                if (self.appData.sortTrainsByTime || self.appData.toStation.abbr != "none" || self.appData.southTrains.count == 0 || self.appData.northTrains.count == 0) {
                    if (self.appData.toStation.abbr != "none") {
                        
                        List {
                            if (self.appData.reviewCard) {
                                NotificationCard(type: "review").padding([.top, .leading, .trailing]).padding( [.bottom,.top], 3).environmentObject(self.appData).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            if (self.appData.showTripDetailFeature) {
                                NotificationCard(type: "tripDetail").padding([.leading, .trailing]).padding([.top,.bottom], 3).environmentObject(self.appData).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            ForEach(self.appData.trips) {trip in
                                
                                
                                Button(action: {
                                    self.tripToShow = trip
                                    self.showTransfers = true
                                    Analytics.logEvent("trip_details_viewed", parameters: [
                                        "user": self.appData.passphrase as NSObject,
                                        "toStation": self.appData.toStation.abbr as NSObject,
                                        "fromStation": self.appData.fromStation.abbr as NSObject
                                    ])
                                }) {
                                    TrainComponent(type: "train",  name: trip.destination, departs: String(trip.leavesIn), unit: "min", color: self.appData.convertColor(color: trip.legs[0].color), eta: trip.destinatonTime).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                                
                                
                            }
                            HStack {
                                Spacer()
                            Text(self.appData.realtimeTripNotice)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center).padding()
                                Spacer()
                            }
                            
                        }.sheet(isPresented: $showTransfers) {
                            TripDetailView(modalShow: self.$showTransfers, tripToShow: self.$tripToShow).environmentObject(self.appData).edgesIgnoringSafeArea(.bottom)
                            
                        }
                        
                    } else {
                        
                        List {
                            if (self.appData.reviewCard) {
                                NotificationCard(type: "review").padding([.top, .leading, .trailing]).padding([.bottom, .top], 3).environmentObject(self.appData).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            ForEach(self.appData.trains) {  train in
                                
                                
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta)
                            }
                            
                        }
                    }
                    
                } else {
                    
                    Picker("",selection: self.$direction) {
                        Text("Northbound").tag(0)
                        Text("Southbound").tag(1)
                        
                    }.pickerStyle(SegmentedPickerStyle()).padding([.top, .leading, .trailing])
                    List {
                        if (self.appData.reviewCard) {
                            NotificationCard(type: "review").padding([.leading, .trailing]).padding([.bottom, .top], 3).environmentObject(self.appData).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
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
