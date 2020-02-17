//
//  TripDetailView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI


struct TripDetailView: View {
    @Binding var modalShow: Bool
    @Binding  var tripToShow: TripInfo
    @State var routeTime = ""
    @State var boardWait = ""
    @EnvironmentObject private var appData: AppData
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trip Details").font(.largeTitle).fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.modalShow = false
                }) {
                    Text("close")
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Departs")
                        .font(.caption)
                    Text(self.tripToShow.originTime)
                        .font(.headline)
                }
                Spacer()
                VStack {
                    Text("Travel")
                        .font(.caption)
                    Text(self.routeTime).font(.subheadline).fontWeight(.bold)
                }

                
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Arrives")
                        .font(.caption)
                    Text(self.tripToShow.destinatonTime)
                        .font(.headline)
                }
            }.padding([.top, .bottom])
            Divider()
            List {
                VStack {
                    
                    ForEach(self.tripToShow.legs) {leg in
                        VStack {
                         
                            if (leg.order == 1) {
                                TripWaitTimeView(type: "board", time: self.boardWait)
                            } else {
                                TripWaitTimeView(type: "transfer", time: leg.transferWait ?? "")
                            }
                            
                            TripComponentView(fromStationName: leg.origin, trainName: leg.trainDestination, stops: leg.stops, type: leg.type, destinationStationName: leg.destination, fromStationTime: leg.originTime, toStationTime: leg.destinationTime, enrouteTime: leg.enrouteTime, color: self.appData.convertColor(color: leg.color)).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            if (leg.order == self.tripToShow.legs.count) {
                                TripWaitTimeView(type: "arrive", time: self.tripToShow.destinatonTime)
                            }
                        }
                    }
                    
                }.edgesIgnoringSafeArea(.bottom).listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
            }.edgesIgnoringSafeArea(.bottom)
            
            
     
        }.edgesIgnoringSafeArea(.bottom).padding().onAppear {
            let originTIme = moment(self.tripToShow.originTime, "HH:mm")
            let destinationTIme = moment(self.tripToShow.destinatonTime, "HH:mm")
            let routeTime = destinationTIme.diff(originTIme, "minutes")
            let boardTime =  moment(self.tripToShow.legs[0].originTime, "HH:mm")
            self.boardWait =  boardTime.fromNow(true)
            print(routeTime, destinationTIme.format(), originTIme.format(), "route time", wait)
            self.routeTime = routeTime.stringValue + "min"
        }
    }
}

struct TripDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TripDetailView(modalShow: .constant(true), tripToShow: .constant(TripInfo(origin: "", destination: "", legs: [], originTime: "21:00", destinatonTime: "21:30", tripTIme: 0.0, leavesIn: 5))).environmentObject(AppData())
    }
}
