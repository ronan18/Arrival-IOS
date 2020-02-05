//
//  HomeView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import UIKit
struct HomeView: View {
    @State var fromModalDisplayed = false
    @State var toModalDisplayed = false
    @State var fromStationSearch = ""
    @EnvironmentObject private var appData: AppData
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "arrivalBlue")
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
    }
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                VStack {
                    VStack {
                    HStack {
                        Text("Arrival").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                      Spacer()
                    }.padding()
                    }
                }.background(Color.arrivalBlueBG).frame(height: geometry.safeAreaInsets.top + 10)
                VStack {
                    HStack {
                        Button  (action: {
                            self.fromStationSearch = ""
                            self.fromModalDisplayed = true
                        }) {
                            if (self.appData.fromStation.id != "loading") {
                                VStack(alignment: .leading) {
                                    Text("from").font(.caption)
                                    Text(self.appData.fromStation.name).font(.headline)
                                }
                            } else {
                                VStack(alignment: .leading) {
                                    Text("from").font(.caption)
                                    Text("Station").font(.headline)
                                }
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
                                        .font(.caption)
                                    List { ForEach(self.appData.closestStations.filter {
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
                            self.toModalDisplayed = true
                        }) {
                            VStack(alignment: .trailing) {
                                Text("to").font(.caption)
                                Text(self.appData.toStation.name).font(.headline)
                            }
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
                                        .font(.caption)
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
                    TrainView()
                    }
                }
            }.onAppear(){
                print("home Appeared")
                self.appData.cylce()
                Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
                    self.appData.cylce()
                }
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().environment(\.colorScheme, .light).environmentObject(AppData())
            HomeView().environment(\.colorScheme, .dark).environmentObject(AppData())
        }
    }
}
