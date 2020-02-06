//
//  SettingsView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/4/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appData: AppData
    init() {
        // To remove all separators including the actual ones:
        
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
                                    
                                }
                            }
                            Text("Settings").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                            Spacer()
                            
                            
                        }
                    }
                }.padding().frame(height: geometry.safeAreaInsets.top + 60).background(Color("arrivalBlue"))
                List {
                    HStack {
                        Text("Account")
                        Spacer()
                        Text(self.appData.passphrase)
                            .fontWeight(.bold).foregroundColor(Color("arrivalBlue"))
                    }
                    HStack {
                        
                        Toggle(isOn: self.$appData.sortTrainsByTime) {
                            Text("Sort trains by time")
                        }
                    }
                    Spacer()
                    if (false) {
                    HStack {
                        Spacer()
                        Button(action: {
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("LOGOUT")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                Spacer()
                            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        }.background(Color.red).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    }
                    
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AppData())
    }
}
