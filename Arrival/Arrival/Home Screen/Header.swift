//
//  Header.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import Foundation
import SwiftUI
public struct ArrivalHeader: View {
    @EnvironmentObject var appState: AppState
    @State var presentAlerts = false
    @State var helpScreen = false

    public var body: some View {
        HStack {
            Text("Arrival")
                .font(.largeTitle)
                .fontWeight(.bold)
            if(self.appState.cycling) {
                ProgressView().progressViewStyle(.circular).tint(.white).padding(.leading,5).frame(width: 20, height: 20).scaleEffect(x: 0.7, y: 0.7, anchor: .center)
            }
            Spacer()
         
            
            Button(action: {
                self.presentAlerts = true
            }) {
                
                IconBadge("exclamationmark.triangle", badge: 1).foregroundColor(.white)
            }.sheet(isPresented: $presentAlerts) {
                //BARTAlertsScreen(appState: appState, open: self.$presentAlerts)
            }
            Button(action: {
                self.helpScreen = true
            }) {
                Image(systemName: "questionmark.circle")
            }.sheet(isPresented: self.$helpScreen) {
               // HelpScreen(appState: appState, close: {self.helpScreen = false})
            }
            Button(action: {
              //  self.appState.settingsModal = true
            }) {
                Image(systemName: "gear")
            }
        }.foregroundColor(.white).padding().background(LinearGradient(gradient: Gradient(colors: [Color("ArrivalBlue"),Color("ArrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct ArrivalHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArrivalHeader()
            Spacer()
        }
    }
}
