//
//  NoNetworkView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/15/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct NoNetworkView: View {
     @EnvironmentObject private var appData: AppData
    @State private var triedConnection = false
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geo in
                Image("map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width - 10)
            }
            .frame(height: 250)
            Text("No Network")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            Text("While arrival caches as much data as possible offline, it requires an internet connection to authenticate and get BART data. Please check your connection then try again")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Spacer()
            if (self.triedConnection) {
                Text("connection failed").foregroundColor(.red)
                
            } else {
                Text(" ").foregroundColor(.red)
                             
            }
            Spacer()
            /*
            Button(action: {
                self.triedConnection = true
                self.appData.testNetwork()
            }) {
                HStack {
                    Spacer()
                    Text("TRY AGAIN")
                        .font(.body)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Spacer()
                }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            
            */
        }.onAppear(perform:{
            self.triedConnection = false
        }).padding()
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkView()
    }
}
