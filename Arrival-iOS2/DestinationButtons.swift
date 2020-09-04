//
//  DestinationButtons.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 6/28/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
struct HomeDestinationChooser: View {
    @EnvironmentObject private var appData: AppData
    @Binding var fromStationSearch: String
    @Binding var fromModalDisplayed: Bool
    @Binding var timeModalDisplayed: Bool
    @Binding var toModalDisplayed: Bool
    var geometry: GeometryProxy
    var body: some View {
  
        HStack(spacing: 0) {
            Button  (action: {
                self.fromStationSearch = ""
                self.fromModalDisplayed = true
            }) {
                if (self.appData.fromStation.id != "loading") {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("from").font(.caption)
                            Spacer()
                        }
                        Text(stationDisplay(self.appData.fromStation.name)).font(.headline)
                    }.lineLimit(1).frame(width: geometry.size.width / 3.25)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("from").font(.caption)
                            Spacer()
                        }
                        Text("Station").font(.headline)
                    }.lineLimit(1).frame(width: geometry.size.width / 3.25)
                }
                
            }.frame(width: geometry.size.width / 3.25).sheet(isPresented: self.$fromModalDisplayed) {
                fromModal(fromStationSearch: self.$fromStationSearch, fromModalDisplayed: self.$fromModalDisplayed).environmentObject(self.appData)
            }
            Spacer()
        
            LeaveButton(geometry:geometry).environmentObject(self.appData)
            
            Spacer()
            Button  (action: {
                self.fromStationSearch = ""
                if (self.appData.fromStation.id != "loading") {
                    self.toModalDisplayed = true
                }
                
            }) {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        Spacer()
                        Text("to").font(.caption)
                    }
                    
                    Text(stationDisplay(self.appData.toStation.name)).font(.headline)
                }.padding(0).lineLimit(1).frame(width: geometry.size.width / 3.25)
            }.frame(width: geometry.size.width / 3.25).sheet(isPresented: self.$toModalDisplayed) {
                ToModal(toModalDisplayed: self.$toModalDisplayed, fromStationSearch: self.$fromStationSearch).environmentObject(self.appData)
            }
            
        }.padding().foregroundColor(.white).background(Color.blackBG)

    }
}

struct fromModal: View {
    
    @EnvironmentObject private var appData: AppData
    @Binding var fromStationSearch: String
    @Binding var fromModalDisplayed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("From Station")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.fromModalDisplayed = false
                }) {
                    Text("Close")
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                SearchBar(text: self.$fromStationSearch).padding(0).padding([.leading, .trailing], -10)
                Spacer().frame(height: 10)
                Text("suggested")
                    .font(.subheadline)
                ScrollView { ForEach(self.appData.fromStationSuggestions.filter {
                    if self.fromStationSearch.count > 0 {
                        return  $0.name.lowercased().contains(self.fromStationSearch.lowercased())
                    } else {
                        return true
                    }
                }){ station in
                    Button(action: {
                        print("set from station", station)
                        self.appData.setFromStation(station: station)
                        self.fromModalDisplayed = false
                    }) {
                        TrainComponent(type: "station", name: station.name)
                    }.padding(.vertical,4).foregroundColor(.blackBorder)
                    
                }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Spacer()
            }
        }.padding().edgesIgnoringSafeArea(.bottom)
    }
}

struct TimeModal: View {
    @EnvironmentObject private var appData: AppData
  
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                
                HStack(alignment: .center) {
                    Text("Choose a time")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        self.appData.loaded = false
                        self.appData.noTrains = false
                        self.appData.cylce()
                        self.appData.timeModalDisplayed = false
                    }) {
                        Text("Close")
                    }
                }
                
                Button(action: {
                    self.appData.trainLeaveTimeType = .now
                }) {
                    HStack {
                        if (self.appData.trainLeaveTimeType == .now) {
                            Image(systemName: "largecircle.fill.circle")
                        } else {
                            Image(systemName: "circle").foregroundColor(.blackBorder)
                        }
                        Text("Leave now").foregroundColor(.blackBorder)
                        Spacer()
                        
                    }
                }
                //   if (self.appData.toStation.name == "none") { // just before release of full time modes
                Button(action: {
                    self.appData.trainLeaveTimeType = .leave
                }) {
                    HStack {
                        if (self.appData.trainLeaveTimeType == .leave) {
                            Image(systemName: "largecircle.fill.circle")
                        } else {
                            Image(systemName: "circle").foregroundColor(.blackBorder)
                        }
                        Text("Leave at").foregroundColor(.blackBorder)
                        Spacer()
                        
                    }
                    //  }
                }
                
                
                DatePicker(selection: self.$appData.leaveDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                    EmptyView()
                }.labelsHidden().disabled(self.appData.trainLeaveTimeType != .leave).frame(maxWidth: geo.size.width - 2)
                
                
                
                
                
                
                
                
                if (self.appData.toStation.name != "none") {
                    Button(action: {
                        self.appData.trainLeaveTimeType = .arrive
                    }) {
                        HStack {
                            if (self.appData.trainLeaveTimeType == .arrive) {
                                Image(systemName: "largecircle.fill.circle")
                            } else {
                                Image(systemName: "circle").foregroundColor(.blackBorder)
                            }
                            Text("Arrive by").foregroundColor(.blackBorder)
                            Spacer()
                            
                        }
                    }
                    
                    DatePicker(selection: self.$appData.arriveDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        EmptyView()
                    }.labelsHidden().disabled(self.appData.trainLeaveTimeType != .arrive).frame(maxWidth: geo.size.width - 2)
                    
                    
                }
                
                
                
                Spacer()
                
            }.padding()
        }
    }
}

struct ToModal: View {
    @EnvironmentObject private var appData: AppData
    @Binding var toModalDisplayed: Bool
    @Binding var fromStationSearch: String
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("To Station")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.toModalDisplayed = false
                }) {
                    Text("Close")
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                
                SearchBar(text: self.$fromStationSearch).padding(0).padding([.leading, .trailing], -10)
                Spacer().frame(height: 10)
                Text("suggested")
                    .font(.subheadline)
                ScrollView { ForEach(self.appData.toStationSuggestions.filter {
                    if ($0.name == self.appData.fromStation.name) {
                        return false
                    } else {
                        if self.fromStationSearch.count > 0 {
                            return  $0.name.lowercased().contains(self.fromStationSearch.lowercased())
                        } else {
                            return true
                        }
                    }
                }) { station in
                    Button(action: {
                        print("set from station", station)
                        self.appData.setToStation(station: station)
                        self.toModalDisplayed = false
                    }) {
                        TrainComponent(type: "station", name: station.name)
                    }.padding(.vertical,4).foregroundColor(.blackBorder)
                    
                }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Spacer()
            }
        }.padding().edgesIgnoringSafeArea(.bottom)
    }
}

struct LeaveButton: View {
    @EnvironmentObject private var appData: AppData
    var geometry: GeometryProxy
   // @Binding var fromStationSearch: String
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }
    func formateTime(_ time: Date) -> String {
        switch self.appData.trainLeaveTimeType {
        case .now:
            return "Now"
        case .leave:
            let timeString = self.dateFormatter.string(from: time)
            print("Time string \(timeString)")
            let momentTime = moment(timeString, "MMM D, YYYY at h:mm:22 A")
            print("time string moment", momentTime.format("MMM D, h:mm a"), momentTime.isValid())
            if (momentTime.isSame(moment(), "day")) {
                return momentTime.format("h:mm a")
            } else if (momentTime.isSame(moment(), "week")) {
                return momentTime.format("ddd h:mm a")
            } else if (momentTime.isValid()) {
                return  momentTime.format("MMM D, h:mm a")
            } else {
                return "Date Error"
            }
            
        case .arrive:
            let timeString = self.dateFormatter.string(from: time)
            print("Time string \(timeString)")
            let momentTime = moment(timeString, "MMM D, YYYY at h:mm:22 A")
            print("time string moment", momentTime.format("MMM D, h:mm a"), momentTime.isValid())
            if (momentTime.isSame(moment(), "day")) {
                return momentTime.format("h:mm a")
            } else if (momentTime.isSame(moment(), "week")) {
                return momentTime.format("ddd h:mm a")
            } else if (momentTime.isValid()) {
                return  momentTime.format("MMM D, h:mm a")
            } else {
                return "Date Error"
            }
            return "test"
            
            
        }
    }
    var body: some View {

        Button  (action: {
            //self.fromStationSearch = ""
            if (self.appData.fromStation.id != "loading") {
                self.appData.timeModalDisplayed = true
            }
            
        }) {
            VStack(alignment: .center) {
                if (self.appData.trainLeaveTimeType == .now) {
                    HStack {
                        Spacer()
                        Text("leave").font(.caption)
                        Spacer()
                    }
                    Text("now").font(.headline)
                } else if (self.appData.trainLeaveTimeType == .leave) {
                    HStack {
                        Spacer()
                        Text("leave").font(.caption)
                        Spacer()
                    }
                    Text(self.formateTime(self.appData.leaveDate)).font(.headline).lineLimit(1)
                } else {
                    HStack {
                        Spacer()
                        Text("arrive").font(.caption)
                        Spacer()
                    }
                    Text(self.formateTime(self.appData.arriveDate)).font(.headline).lineLimit(1)
                }
                
            }.multilineTextAlignment(.center).frame(width: geometry.size.width / 4)
        }.frame(width: geometry.size.width / 4).sheet(isPresented: self.$appData.timeModalDisplayed) {
            TimeModal().environmentObject(self.appData)
        }
    
    }
}
/*

struct DestinationButtons_Previews: PreviewProvider {
    static var previews: some View {
    HomeDestinationChooser(fromStationSearch: .constant(""), fromModalDisplayed: .constant(false), timeModalDisplayed: .constant(false), toModalDisplayed: .constant(false)).environmentObject(AppData())
    }
}
*/
