//
//  HomeView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics
let tripOptionsMultiplier = 3.3
struct HomeView: View {
    @State var fromModalDisplayed = false
    @State var toModalDisplayed = false
    @State var fromStationSearch = ""
    @State var locationTimeout = false
    @State var timeModalDisplayed = false
    @EnvironmentObject private var appData: AppData
    private var leaveTimesEnabled = true
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
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    init() {
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        
        VStack(spacing: 0) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    VStack {
                        Spacer()
                        VStack(spacing: 0) {
                            HStack { Text("Arrival").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                                Spacer()
                                
                                Button(action: {
                                    self.appData.screen = "settings"
                                }) {
                                    
                                    Image(systemName: "gear").font(.headline).foregroundColor(.white).padding(5)
                                }
                            }
                        }
                    }.padding().frame(height: geometry.safeAreaInsets.top + 60).background(Color("arrivalBlue")).sheet(isPresented: self.$appData.showTripDetailsFromLink) {
                        if (!self.appData.dynamicLinkTripDataShow) {
                            Text("Loading Trip Info")
                        } else {
                            
                            TripDetailView(modalShow: self.$appData.showTripDetailsFromLink, tripToShow: self.$appData.dynamicLinkTripData).environmentObject(self.appData).edgesIgnoringSafeArea(.bottom)
                        }
                        
                    }
                    
                    VStack(spacing: 0) {
                        
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
                                        List { ForEach(self.appData.fromStationSuggestions.filter {
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
                                            }
                                            
                                            }
                                        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        Spacer()
                                    }
                                }.padding().edgesIgnoringSafeArea(.bottom)
                            }
                            Spacer()
                            if (self.leaveTimesEnabled) {
                            Button  (action: {
                                self.fromStationSearch = ""
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
                                        List { ForEach(self.appData.toStationSuggestions.filter {
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
                                            }
                                            
                                            }
                                        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        Spacer()
                                    }
                                }.padding().edgesIgnoringSafeArea(.bottom)
                            }
                            
                        }.padding().foregroundColor(.white).background(Color.blackBG)
                        
                        if (!self.appData.network) {
                            HStack {
                                Spacer()
                                Text("No Network")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white).padding()
                                Spacer()
                            }.background(Color.red)
                        }
                        if (!self.appData.appMessage.isEmpty) {
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Text(self.appData.appMessage)
                                        .font(.callout)
                                        .foregroundColor(Color.white)
                                    if (self.appData.appLink.count > 0) {
                                        
                                        Button(action: {
                                            Analytics.logEvent("appMessageClicked", parameters: [
                                                "link": self.appData.appLink as NSObject])
                                            if let url = URL(string: self.appData.appLink) {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text("Learn more")
                                        }
                                        
                                        
                                    }
                                }
                                Spacer()
                                
                                
                            }.padding().background(Color("darkGrey"))
                        }
                        
                        if (self.appData.fromStation.abbr != "load" || !self.locationTimeout && self.appData.locationAcess) {
                            
                            TrainView()
                        } else {
                            Spacer()
                            Button(action: {
                                self.fromStationSearch = ""
                                self.fromModalDisplayed = true
                            }) {
                                Text("Please choose a from station")
                                    .multilineTextAlignment(.center)
                            }
                            if (!self.appData.locationAcess) {
                                Spacer()
                                    .frame(height: 5.0)
                                Text("enable location acess to allow Arrival to automatically determine your closest station")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center).padding()
                            }
                            
                            
                            Spacer()
                        }
                        
                        
                        
                    }
                }
            }
        }.edgesIgnoringSafeArea(.top).onAppear(){
            print("home Appeared")
            // Analytics.setScreenName("home", screenClass: "home")
            self.appData.cylce()
            
            Timer.scheduledTimer(withTimeInterval: self.appData.cycleTimer, repeats: true) { timer in
                self.appData.cylce()
            }
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                self.locationTimeout = true
                if (self.appData.fromStation.abbr == "load") {
                    Analytics.logEvent("locationTimeOut", parameters: [:])
                }
            }
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                HomeView().environment(\.colorScheme, .light).environmentObject(AppData())
                HomeView().environment(\.colorScheme, .dark).environmentObject(AppData())
            }
            /*
             Group {
             HomeView().environment(\.colorScheme, .light).environmentObject(AppData()).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
             HomeView().environment(\.colorScheme, .dark).environmentObject(AppData()).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
             }*/
        }
    }
}
