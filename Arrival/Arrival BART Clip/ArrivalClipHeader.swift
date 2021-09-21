//
//  ArrivalClipHeader.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct ArrivalClipHeader: View {
    @ObservedObject var appState: AppClipState
    @State var presentAlerts = false
    public var body: some View {
        HStack {
            Text("Arrival")
                .font(.largeTitle)
                .fontWeight(.bold)
            if((self.appState.trainsLoading && !(self.appState.locationAuthState == .notAuthorized && self.appState.fromStation == nil)) || self.appState.cycling > 0) {
                ProgressView().progressViewStyle(.circular).tint(.white).padding(.leading,5).frame(width: 20, height: 20).scaleEffect(x: 0.7, y: 0.7, anchor: .center)
            }
            Spacer()
            
            Text("c\(String(self.appState.cycling))")
            
           
           
        }.foregroundColor(.white).padding().background(LinearGradient(gradient: Gradient(colors: [Color("ArrivalBlue"),Color("ArrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct ArrivalClipHeader_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalClipHeader(appState: AppClipState())
    }
}
