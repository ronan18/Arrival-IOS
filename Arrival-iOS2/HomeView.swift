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
  
    @State var locationTimeout = false
    @State var fromModalDisplayed = false
    @State var toModalDisplayed = false
    @State var fromStationSearch = ""
    @State var timeModalDisplayed = false
    @EnvironmentObject private var appData: AppData
    private var leaveTimesEnabled = true
    var navSpace: CGFloat = 100

    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    init() {
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        if #available(iOS 14.0, *) {
            // modern code
            navSpace = 100
        } else {
            // Fallback on earlier versions
            navSpace = 60
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HomeHeader(geometry: geometry, navSpace: self.navSpace)
                    VStack(spacing: 0) {
                        
                        HomeDestinationChooser(fromStationSearch: self.$fromStationSearch, fromModalDisplayed: self.$fromModalDisplayed, timeModalDisplayed: self.$timeModalDisplayed, toModalDisplayed: self.$toModalDisplayed, geometry: geometry).environmentObject(self.appData).padding(0).background(Color.red)
                        
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
                                        .foregroundColor(Color.white).multilineTextAlignment(.center)
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
                    .padding(0.0)
                }
            }
        }.edgesIgnoringSafeArea(.top).onAppear(perform: appearCode)
        
    }
    func appearCode() {
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

struct HomeHeader: View {
    var geometry: GeometryProxy
    var navSpace: CGFloat
    @EnvironmentObject private var appData: AppData
    var body: some View {
      
        VStack(alignment: .center) {
        
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
        }.padding().background(Color("arrivalBlue")).frame(height: geometry.safeAreaInsets.top + navSpace).sheet(isPresented: self.$appData.showTripDetailsFromLink) {
            if (!self.appData.dynamicLinkTripDataShow) {
                Text("Loading Trip Info")
            } else {
                
                TripDetailView(modalShow: self.$appData.showTripDetailsFromLink, tripToShow: self.$appData.dynamicLinkTripData).environmentObject(self.appData).edgesIgnoringSafeArea(.bottom)
            }
            
        }
        
    }
}


