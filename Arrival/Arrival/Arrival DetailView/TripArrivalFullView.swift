//
//  TripArrivalFullView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/13/23.
//

import Foundation
import SwiftUI
import ArrivalGTFS
import ArrivalCore
struct TripArrivalFullView: View {
    @EnvironmentObject var appState: AppState
    var trip: TripPlan
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header:
                        VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Departs").font(.caption)
                                TimeDisplayText(self.trip.connections.first!.startTime, mode: .etd)
                            }
                            Spacer()
                            VStack(alignment: .center) {
                                Text("travel").font(.caption)
                                HStack(alignment: .firstTextBaseline, spacing: 0) {
                                    Text(String(Int(self.trip.time / 60))).font(.headline)
                                    Text("min").font(.caption)
                                }
                               // TimeDisplayText(self.trip.connections.first!.startTime, mode: .etd)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Arrives").font(.caption)
                                TimeDisplayText(self.trip.connections.last!.endTime, mode: .etd)
                            }
                        }.padding()
                        Divider()
                    }.background(.white)) {
                        VStack {
                            Text("\(Image(systemName: "clock")) wait \(Int(trip.connections.first!.startTime.timeIntervalSinceNow / 60)) min at \(ArrivalDataManager.shared.stations.byStopID(trip.connections.first!.startStation)?.stopName ?? "")").font(.subheadline).multilineTextAlignment(.center)
                            
                            ForEach(self.trip.steps) {step in
                                switch step {
                                case .ride(let ride):
                                    PlanRideStep(ride:ride).environmentObject(appState)
                                case .tranfer(let transfer):
                                    Text("wait for \(Int(transfer.duration / 60)) min at \(ArrivalDataManager.shared.stations.byStopID(transfer.station)?.stopName ?? "")").font(.subheadline).multilineTextAlignment(.center)
                                }
                            }
                            Text("\(Image(systemName: "flag.checkered")) arrive at \(ArrivalDataManager.shared.stations.byStopID(trip.connections.last!.endStation)?.stopName ?? "")").font(.subheadline).multilineTextAlignment(.center)
                        }.padding(.horizontal)
                    }
                   
                }
            }.navigationTitle("Trip Details").navigationBarItems(trailing: Button(action: {
                self.appState.arrivalToDisplay = nil
            }){
                Text("Close")
            })
        }
    }
}
struct PlanRideStep: View {
    @EnvironmentObject var appState: AppState
    @State var redacted = false
    @State var start: StopTime? = nil
    @State var end: StopTime? = nil
    @State var trip: Trip? = nil
    @State var route: Route? = nil
    @State var intermediates: [StopTime] = []
    @State var expanded = false
   
    var ride: TripPlanRide
    public var body: some View {
        HStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.forward.circle.fill").foregroundColor(self.route?.routeColor == "FFFF33" ? Color("DarkYellow") :  Color(bartColor: self.route?.routeColor)).symbolRenderingMode(self.route?.routeColor == "FFFF33" ? .monochrome :/*@START_MENU_TOKEN@*/.hierarchical/*@END_MENU_TOKEN@*/)
                            
                            Text("\(String((self.trip?.tripHeadsign ?? "").split(separator: " / ").last ?? ""))").font(.headline).lineLimit(1)
                        }
                        Text(ArrivalDataManager.shared.stations.byStopID(start?.stopId ?? "")?.stopName ?? trip?.id ?? "")
                    }
                    Spacer()
                    if(self.appState.realtimeStopTimes[start?.id ?? ""] != nil) {
                       
                   // Text(String(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)).font(.system(size: 9))
                    Image(systemName: "wifi").font(.system(size: 9))
                        
                    }
                    TimeDisplayText(Date(bartTime: start?.arrivalTime ?? "25:00") + TimeInterval((self.appState.realtimeStopTimes[start?.id ?? ""]?.arrival.delay ?? 0)), mode: .etd)
                }
                if (self.intermediates.count > 0 && self.end != nil && self.start != nil) {
                    DisclosureGroup("\(Int(Date(bartTime: end!.arrivalTime).timeIntervalSince(Date(bartTime: start!.departureTime)) / 60)) min, \(self.intermediates.count) stops", isExpanded: self.$expanded) {
                        ForEach(intermediates.sorted(by: {a, b in
                            return a.arrivalTime < b.arrivalTime
                        })) {stopTime in
                            HStack {
                                Text(ArrivalDataManager.shared.stations.byStopID(stopTime.stopId)?.stopName ?? stopTime.stopId).font(.subheadline)
                                Spacer()
                                HStack(alignment: .firstTextBaseline, spacing: 0) {
                                    Text(String(Int(Date(bartTime: stopTime.arrivalTime).timeIntervalSince(Date(bartTime: intermediates.last(where: {time in
                                        return time.stopSequence < stopTime.stopSequence
                                    })?.departureTime ?? self.start?.departureTime ?? "11:00:00")) / 60))).font(.subheadline)
                                    Text(" min").font(.caption)
                                }
                              
                            }
                        }
                    }.padding(.bottom).padding(.top, 2).font(.subheadline)
                } else {
                    if (self.start != nil && end != nil) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                          
                           
                            Text(String(Int(Date(bartTime: end!.arrivalTime).timeIntervalSince(Date(bartTime: start!.departureTime)) / 60))).font(.subheadline)
                            Text(" min").font(.caption)
                            Spacer()
                        }.padding(.vertical, 2)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                      
                        Text(ArrivalDataManager.shared.stations.byStopID(end?.stopId ?? "")?.stopName ?? trip?.id ?? "").font(.headline)
                    }
                    Spacer()
                    if(self.appState.realtimeStopTimes[end?.id ?? ""] != nil) {
                       
                   // Text(String(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)).font(.system(size: 9))
                    Image(systemName: "wifi").font(.system(size: 9))
                        
                    }
                    TimeDisplayText(Date(bartTime: end?.arrivalTime ?? "25:00") + TimeInterval((self.appState.realtimeStopTimes[end?.id ?? ""]?.arrival.delay ?? 0)), mode: .etd)
                }
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.redacted ? Color.gray : Color(bartColor: self.route?.routeColor)); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).task {
            self.trip = await ArrivalDataManager.shared.trip(tripId: self.ride.trip)
            self.route = await ArrivalDataManager.shared.route(id: self.trip?.routeId ?? "")
            self.ride.intermediaryStopTimes.forEach {time in
                
                Task {
                  
                    guard let result = await ArrivalDataManager.shared.stopTime(by: time) else {
                        return
                    }
                    self.intermediates.append(result)
                   
                }
               
            }
            
            self.start = await ArrivalDataManager.shared.stopTime(by: self.ride.startStopTime)
            self.end = await ArrivalDataManager.shared.stopTime(by: self.ride.endStopTime)
           
        }
    }
}
