//
//  TrainArrivalFullView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/13/23.
//

import Foundation
import SwiftUI
import ArrivalGTFS
import ArrivalCore
struct TrainArrivalFullView: View {
    @EnvironmentObject var appState: AppState
    @State var selected: StopTime? = nil
    @State var tripStopTimes: [StopTime] = []
    @State var loading = true
    @State var timeDisplayMode: TimeDisplayType = .etd
    var train: Train
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    TrainViewHeader(selected: self.$selected, train: train).environmentObject(appState)
                    Divider()
                  
                    if (self.loading) {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView().progressViewStyle(.circular)
                                Spacer()
                            }
                            Spacer()
                        }.frame(minHeight: 500).padding(.horizontal)
                    } else {
                        ForEach(self.tripStopTimes) {time in
                            VStack {
                                HStack {
                                    Text(ArrivalDataManager.shared.stations.byStopID(time.stopId)?.stopName ?? "").font(.headline)
                                    Spacer()
                                    if(self.appState.realtimeStopTimes[time.id] != nil) {
                                        
                                        Image(systemName: "wifi").font(.system(size: 9))
                                    }
                                    HStack {
                                       
                                        TimeDisplayText((Date(bartTime: time.arrivalTime) + TimeInterval(self.appState.realtimeStopTimes[time.id]?.arrival.delay ?? 0)), mode: self.timeDisplayMode)
                                    }.onTapGesture(perform: {
                                        withAnimation {
                                            self.timeDisplayMode = self.timeDisplayMode == .etd ? .timeTill : .etd
                                        }
                                    })
                                }.padding(.vertical, 5)
                                Divider()
                            }.padding(.horizontal)
                        }
                    }
                    
                }
            }.navigationTitle(train.route.routeShortName ?? "").navigationBarItems(trailing: Button(action: {
                self.appState.arrivalToDisplay = nil
            }){
                Text("Close")
            }).navigationBarTitleDisplayMode(.inline).onAppear {
                switch self.appState.arrivalToDisplay?.type {
                case .train(let train):
                    self.selected = train.stopTime
               
                    return
                 default:
                    return
                }
            }.onChange(of: self.selected, perform: {val in
                self.loading = true
                var data: [StopTime] = []
                self.tripStopTimes = []
                Task {
                    data = await ArrivalDataManager.shared.stopTimes(for: self.selected?.tripId ?? "")
                    print(data.count, "in app")
                    withAnimation {
                        self.loading = false
                        self.tripStopTimes = data.filter({time in
                            return time.stopSequence > self.selected?.stopSequence ?? 0
                        })

                    }
                }
            })
        }
    }
}

struct TrainViewHeader: View {
    @EnvironmentObject var appState: AppState
    @Binding var selected: StopTime?
   
    @State var loading = true
    var train: Train
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Image(systemName: "arrow.forward.circle.fill").foregroundColor(train.route.routeColor == "FFFF33" ? Color("DarkYellow") : Color(bartColor: train.route.routeColor)).symbolRenderingMode(train.route.routeColor == "FFFF33" ? .monochrome :/*@START_MENU_TOKEN@*/.hierarchical/*@END_MENU_TOKEN@*/)
                    
                    Text(self.train.direction).font(.headline).lineLimit(1)
                    Spacer()
                }
                Text(ArrivalDataManager.shared.stations.byStopID(train.stopTime.stopId)?.stopName ?? "")
            }.padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(self.appState.arrivals.filter({arr in
                        switch arr.type {
                        case .train(let train):
                            return train.route.routeId == self.train.route.routeId
                        default:
                            return false
                        }
                        
                    })) {arrival in
                        Group {
                            switch arrival.type {
                            case .train(let dispTrain):
                                Button (action: {
                                    self.selected = dispTrain.stopTime
                                }) {
                                    HStack {
                                        
                                        TimeDisplayText(Date(bartTime: dispTrain.stopTime.arrivalTime) + TimeInterval(self.appState.realtimeStopTimes[dispTrain.stopTime.id]?.arrival.delay ?? 0),mode: .timeTill)
                                        
                                        if(self.appState.realtimeStopTimes[dispTrain.stopTime.id] != nil) {
                                            
                                            // Text(String(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)).font(.system(size: 9))
                                            Image(systemName: "wifi").font(.system(size: 9))
                                        }
                                        
                                    }.padding(.vertical, 5).padding(.horizontal, 10).frame(width: 85).cornerRadius(10).background(dispTrain.stopTime == self.selected ? Color(bartColor: self.train.route.routeColor) : Color("CardBG")).overlay(
                                        RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(bartColor: self.train.route.routeColor), lineWidth:3)
                                    ).cornerRadius(10.0)
                                }.foregroundColor(.black)
                                
                                
                            default:
                                Text("")
                            }
                        }
                    }
                    Spacer()
                }.padding(.leading)
            }
        }
    }
}
