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
extension AnyTransition {
    static var trainCardTransition: AnyTransition {
        let transition = AnyTransition.asymmetric(insertion: AnyTransition.offset(x: 0, y: 50)
            .combined(with: AnyTransition.opacity), removal: AnyTransition.opacity)
        return transition
    }
}
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
                Text("No Trains").transition(.trainCardTransition).animation(.spring())
                Spacer()
            } else if (self.appData.trains.isEmpty || !self.appData.loaded) {
                Spacer().frame(height: 8)
                TrainComponent(type: "skeleton").padding(.horizontal)
                TrainComponent(type: "skeleton").padding(.horizontal)
                TrainComponent(type: "skeleton").padding(.horizontal)
                Spacer()
            } else {
                if (self.appData.sortTrainsByTime || self.appData.toStation.abbr != "none" || self.appData.southTrains.count == 0 || self.appData.northTrains.count == 0) {
                    if (self.appData.toStation.abbr != "none") {
                        
                        ScrollView {
                            Spacer().frame(height: 8)
                            if (self.appData.showTripDetailFeature) {
                                NotificationCard().animation(.none)
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
                                    TrainComponent(type: "train",  name: trip.destination, departs: String(trip.leavesIn), unit: "min", color: self.appData.convertColor(color: trip.legs[0].color), eta: trip.destinatonTime).foregroundColor(Color("Text")).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                                
                                
                            }.animation(.none)
                            HStack {
                                Spacer()
                                VStack {
                                    
                                    Text(self.appData.realtimeTripNotice)
                                        .font(.caption)
                                        .foregroundColor(Color.gray)
                                        .multilineTextAlignment(.center).padding().animation(.none)
                                }
                                Spacer()
                            }
                            
                        }.transition(.trainCardTransition).animation(.spring()).edgesIgnoringSafeArea(.bottom).padding(.horizontal).sheet(isPresented: $showTransfers) {
                            TripDetailView(modalShow: self.$showTransfers, tripToShow: self.$tripToShow).environmentObject(self.appData)
                            
                        }
                        
                    } else {
                        
                        ScrollView {
                            Spacer().frame(height: 8)
                            ForEach(self.appData.trains) {  train in
                                
                                
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).padding(.horizontal)
                            }.animation(.none)
                            if (self.appData.trainLeaveTimeType == .leave) {
                                Text(self.appData.leaveTrainRealtimeNotice).font(.caption)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center).padding().animation(.none)
                            }
                            
                        }.transition(.trainCardTransition).animation(.spring())
                    }
                    
                } else {
                    Spacer().frame(height: 8)
                    Picker("",selection: self.$direction) {
                        Text("Northbound").tag(0)
                        Text("Southbound").tag(1)
                        
                    }.pickerStyle(SegmentedPickerStyle()).padding([.leading, .trailing]).transition(.opacity).animation(.spring())
                    ScrollView {
                        if (self.direction == 0) {
                            ForEach(self.appData.northTrains) { train in
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).padding(.horizontal)
                            }.animation(.none)
                              if (self.appData.trainLeaveTimeType == .leave) {
                            Text(self.appData.leaveTrainRealtimeNotice).font(.caption)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center).padding().animation(.none)
                            }
                        } else {
                            ForEach(self.appData.southTrains) { train in
                                TrainComponent(type: "train",  name: train.direction, cars: train.cars, departs: train.time,unit: train.unit, color: self.appData.convertColor(color: train.color), eta: train.eta).padding(.horizontal)
                            }.animation(.none)
                              if (self.appData.trainLeaveTimeType == .leave) {
                            Text(self.appData.leaveTrainRealtimeNotice).font(.caption)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center).padding().animation(.none)
                            }
                        }
                    }.transition(.trainCardTransition).animation(.spring())
                }
            }
            
            
        }.edgesIgnoringSafeArea(.bottom).animation(.none)
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
