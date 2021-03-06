//
//  SettingsView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseCrashlytics
struct SettingsView: View {
    @EnvironmentObject private var appData: AppData
    var navSpace: CGFloat = 100
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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Button(action: {
                                self.appData.screen = "home"
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left").foregroundColor(.white).padding(5)
                                    Text("Settings").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                                    
                                }
                            }
                            
                            Spacer()
                            
                            
                        }
                    }
                }.padding().frame(height: geometry.safeAreaInsets.top + self.navSpace).background(Color("arrivalBlue"))
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
                VStack {
                    VStack {
                        HStack {
                            Text("Account ID")
                            Spacer()
                            Text(self.appData.passphrase)
                                .fontWeight(.bold).foregroundColor(Color("arrivalBlue"))
                        }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.vertical, 4)
                        HStack {
                            
                            Toggle(isOn: self.$appData.sortTrainsByTime) {
                                Text("Sort trains by time")
                            }.padding(.trailing, 1.2)
                        }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.vertical, 4)
                        HStack {
                            Text("App version")
                            Spacer()
                            Text(self.appData.appVersion)
                                .fontWeight(.bold)
                        }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.vertical, 4)
                        HStack {
                            Text("Station version")
                            Spacer()
                            Text(String(self.appData.currentStationVersion))
                                .fontWeight(.bold)
                        }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.vertical, 4)
                    }
                    Spacer()
                    #if DEBUG
                    HStack {
                        Text("Debug mode")
                        Spacer()
                        Text(String(self.appData.debug))
                            .fontWeight(.bold)
                    }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    HStack {
                        Spacer()
                        Button(action: {
                            self.appData.logOut()
                        }) {
                            HStack {
                                Spacer()
                                Text("LOGOUT")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .foregroundColor(.red)
                                Spacer()
                            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }
                    #endif
                    Spacer().frame(height: 20)
                    
                    Text(self.appData.aboutText)
                        .multilineTextAlignment(.center).font(.subheadline).foregroundColor(.gray)
                    TermsOfSeriviceView()
                    
                    
                    
                }.padding()
                
            }
        }.edgesIgnoringSafeArea(.top).onAppear() {
            //   Analytics.setScreenName("settings", screenClass: "settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AppData())
    }
}
