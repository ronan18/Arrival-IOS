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

struct HomeView: View {
    @State var fromModalDisplayed = false
    @State var toModalDisplayed = false
    @State var fromStationSearch = ""
    @State var locationTimeout = false
    @EnvironmentObject private var appData: AppData
    
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
                    }.padding().frame(height: geometry.safeAreaInsets.top + 60).background(Color("arrivalBlue"))
                    
                    VStack(spacing: 0) {
                        HStack {
                            Button  (action: {
                                self.fromStationSearch = ""
                                self.fromModalDisplayed = true
                            }) {
                                if (self.appData.fromStation.id != "loading") {
                                    VStack(alignment: .leading) {
                                        Text("from").font(.caption)
                                        Text(self.appData.fromStation.name).font(.headline)
                                    }.lineLimit(1)
                                } else {
                                    VStack(alignment: .leading) {
                                        Text("from").font(.caption)
                                        Text("Station").font(.headline)
                                    }.lineLimit(1)
                                }
                                
                            }.sheet(isPresented: self.$fromModalDisplayed) {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        Text("From Station")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        Spacer()
                                        Button(action: {
                                            self.fromModalDisplayed = false
                                        }) {
                                            Text("Dismiss")
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        
                                        TextField("Search for a Station", text: self.$fromStationSearch)
                                            .padding()
                                            .background(Color.inputBackground)
                                            .cornerRadius(10)
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
                            Button  (action: {
                                self.fromStationSearch = ""
                                if (self.appData.fromStation.id != "loading") {
                                    self.toModalDisplayed = true
                                }
                                
                            }) {
                                VStack(alignment: .trailing) {
                                    Text("to").font(.caption)
                                    Text(self.appData.toStation.name).font(.headline)
                                }.lineLimit(1)
                            }.sheet(isPresented: self.$toModalDisplayed) {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        Text("To Station")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        Spacer()
                                        Button(action: {
                                            self.toModalDisplayed = false
                                        }) {
                                            Text("Dismiss")
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        
                                        TextField("Search for a Station", text: self.$fromStationSearch)
                                            .padding()
                                            .background(Color.inputBackground)
                                            .cornerRadius(10)
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
            Group {
                HomeView().environment(\.colorScheme, .light).environmentObject(AppData()).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                HomeView().environment(\.colorScheme, .dark).environmentObject(AppData()).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            }
        }
    }
}
