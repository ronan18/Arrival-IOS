//
//  HomeScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import SwiftUI
import ArrivalCore
import ArrivalGTFS
struct HomeScreen: View {
    @EnvironmentObject var appState: AppState
   
    var body: some View {
        VStack(spacing: 0) {
            ArrivalHeader().environmentObject(appState)
            DestinationBar().environmentObject(appState)
            VStack {
            ScrollView {
                ForEach(self.appState.arrivals, id: \.id) {arrival in
                    Button(action: {
                        self.appState.arrivalToDisplay = arrival
                    }) {
                        ArrivalCard(arrival: arrival).padding(.vertical, 2).environmentObject(appState)
                    }
                    
                    
                }
                if (self.appState.arrivals.count == 0 && self.appState.cycling == false) {
                    Button(action: {
                        Task {
                            await self.appState.cycle()
                        }
                        
                    }) {
                        Text("Cycle")
                    }
                }
            }.refreshable {
                await self.appState.cycle()
            }
            }.padding().sheet(item: self.$appState.arrivalToDisplay, content: {arrival in
                ArrivalFullView(arrival: arrival).environmentObject(appState)
            })
            
            Spacer()
        }.edgesIgnoringSafeArea(.bottom).task{
            await self.appState.setup()
           // await self.appState.cycle()
            
        }
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
