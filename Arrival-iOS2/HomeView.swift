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
    @State var fromStationSearch = ""
    @EnvironmentObject private var appData: AppData
    init() {
        // 1.
        UINavigationBar.appearance().backgroundColor = UIColor(named: "arrivalBlue")
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
    }
    var body: some View {
        NavigationView {
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
                        
                    }.sheet(isPresented: $fromModalDisplayed) {
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
                                Text("suggested")
                                    .font(.caption)
                                List(self.appData.closestStations.filter {
                                    if self.fromStationSearch.count > 0 {
                                        return  $0.name.contains(self.fromStationSearch)
                                    } else {
                                        return true
                                    }
                                }) { station in
                                    Button(action: {
                                        print("set from station", station)
                                        self.appData.setFromStation(station: station)
                                        self.fromModalDisplayed = false
                                    }) {
                                        TrainComponent(type: "station", name: station.name)
                                    }
                                    
                                }
                                Spacer()
                            }
                        }.padding()
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("to").font(.caption)
                        Text("Station").font(.headline)
                    }
                }.padding().foregroundColor(.white).background(Color.blackBG)
                TrainView()
            }.navigationBarTitle("Arrival")
        }.padding(.top, 43.0).edgesIgnoringSafeArea(.top).onAppear(){
            print("home Appeared")
            self.appData.cylce()
            Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
                self.appData.cylce()
            }
        }
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
