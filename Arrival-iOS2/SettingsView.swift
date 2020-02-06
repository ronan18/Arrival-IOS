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
                                Image(systemName: "chevron.left").foregroundColor(.white)
                                    
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
                                         Text("Sort trains by time")
                                         Spacer()
                                         Text("no")
                                             .fontWeight(.bold).foregroundColor(Color("arrivalBlue"))
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
