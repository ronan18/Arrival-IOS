//
//  ArrivalHeader.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import ArrivalUI

public struct ArrivalHeader: View {
    @ObservedObject var appState: AppState
    @State var presentAlerts = false
    @State var helpScreen = false
    public var body: some View {
        HStack {
            Text("Arrival")
                .font(.largeTitle)
                .fontWeight(.bold)
            if((self.appState.trainsLoading && !(self.appState.locationAuthState == .notAuthorized && self.appState.fromStation == nil)) || self.appState.cycling > 0) {
                ProgressView().progressViewStyle(.circular).tint(.white).padding(.leading,5).frame(width: 20, height: 20).scaleEffect(x: 0.7, y: 0.7, anchor: .center)
            }
            Spacer()
            if (self.appState.mode == .development) {
            Text("c\(String(self.appState.cycling))")
            }
            
            Button(action: {
                self.presentAlerts = true
            }) {
                
                IconBadge("exclamationmark.triangle", badge: self.appState.alerts.count).foregroundColor(.white)
            }.sheet(isPresented: $presentAlerts) {
                BARTAlertsScreen(appState: appState, open: self.$presentAlerts)
            }
            /*
            Button(action: {
                self.helpScreen = true
            }) {
                Image(systemName: "questionmark.circle")
            }.sheet(isPresented: self.$helpScreen) {
                HelpScreen(appState: appState, close: {self.helpScreen = false})
            }*/
            Button(action: {
                self.appState.settingsModal = true
            }) {
                Image(systemName: "gear")
            }.sheet(isPresented: .init(get: {
                return self.appState.settingsModal
            }, set: {
                self.appState.settingsModal = $0
            })) {
                SettingsScreen(appState: appState)
            }
        }.foregroundColor(.white).padding().background(LinearGradient(gradient: Gradient(colors: [Color("ArrivalBlue"),Color("ArrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct ArrivalHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArrivalHeader(appState: AppState())
            Spacer()
        }
    }
}
