//
//  HomeTrains.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import Foundation
import SwiftUI
import ArrivalUI
import ArrivalCore
struct HomeTrains: View {
    @ObservedObject var appState: AppState
    @State var timeDisplayMode = TimeDisplayType.timeTill
    @State var filteredTrains: [Train] = []
    func filterTrains (_ trains: [Train], direction: TrainDirection? = nil) -> [Train] {
        
        switch self.appState.directionFilter {
        case 1 :
            return self.appState.northTrains
        case 2:
            return self.appState.southTrains
        default:
            return trains
        }
    }
    var body: some View {
        VStack {
            Picker(selection: .init(get: {self.appState.directionFilter}, set: {
                self.appState.directionFilter = $0
                print("updating manually direction filter")
                switch $0 {
                case 1 :
                  //  self.filteredTrains = self.appState.northTrains
                    self.appState.logDirectionEvent(.north)
                    return
                case 2:
                  //  self.filteredTrains = self.appState.southTrains
                    self.appState.logDirectionEvent(.south)
                    return
                default:
                   // self.filteredTrains = self.appState.trains
                    return
                }
            }), label: Text("Train Direction")) {
                Text("Northbound").tag(1)
                Text("Southbound").tag(2)
                Text("All").tag(3)
            }.pickerStyle(SegmentedPickerStyle()).disabled(self.appState.trainsLoading).opacity(self.appState.trainsLoading ? 0.8 : 1)
            if (self.appState.trainsLoading) {
                List() {
                    ForEach(0..<5) {i in
                        TrainCard(train: MockUpData().train, timeDisplayMode: self.$timeDisplayMode, redacted: true).redacted(reason: .placeholder).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                    }
                   
                    
                }.listStyle(.plain)
            } else {
            if (filteredTrains.count > 0) {
            List() {
            
                ForEach(filteredTrains) {train in
                    TrainCard(train: train, timeDisplayMode: self.$timeDisplayMode).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                }.edgesIgnoringSafeArea(.bottom)
                
            }.listStyle(.plain).refreshable {
                Task(priority: .userInitiated) {
                    await self.appState.cycle()
                    await self.appState.refreshAlerts()
                }
            }.edgesIgnoringSafeArea(.bottom)
            } else {
                VStack {
                    Spacer()
                    Text("No Trains in this direction")
                    if (appState.trains.count == 0) {
                        Text("you may be out of service hours or your network connection is down.").font(.caption).multilineTextAlignment(.center)
                    }
                    Spacer()
                }
            }
            }
        }.padding().edgesIgnoringSafeArea(.bottom).onChange(of: self.appState.trains, perform: { trains in
            switch self.appState.directionFilter {
            case 1 :
                self.filteredTrains = self.appState.northTrains
            case 2:
                self.filteredTrains = self.appState.southTrains
            default:
                self.filteredTrains = trains
            }
        }).onChange(of: self.appState.directionFilter, perform: { direction in
            print("auto updating direction filter")
            switch direction {
            case 1 :
                self.filteredTrains = self.appState.northTrains
               // self.appState.logDirectionEvent(.north)
            case 2:
                self.filteredTrains = self.appState.southTrains
              //  self.appState.logDirectionEvent(.south)
            default:
                self.filteredTrains = self.appState.trains
            }
            
        })
    }
}

struct HomeTrains_Previews: PreviewProvider {
    static var previews: some View {
        HomeTrains(appState: AppState())
    }
}
