//
//  AuthorizeLocationView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/28/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore

struct AuthorizeLocationView: View {
    @ObservedObject var appState: AppState
    var body: some View {
        VStack {
            Spacer().frame(height: 25)
            Image(systemName: "exclamationmark.octagon.fill").font(.system(size: 100)).symbolRenderingMode(.hierarchical).padding().foregroundColor(.yellow)
            Text("No Departure Station Specified").font(.title2).bold()
            HStack {
                Button(action: {
                    if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                        if UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                }) {
                    Image(systemName: "location.fill.viewfinder")
                    Text("use location")
                }.buttonStyle(.borderedProminent).controlSize(.small).buttonBorderShape(.capsule)
                Text("or").font(.subheadline)
                Button(action: {
                    self.appState.fromStationChooser = true
                }) {
                    Image(systemName: "list.dash")
                    Text("specify station")
                }.buttonStyle(.bordered).controlSize(.small).buttonBorderShape(.capsule)
          
            }.padding(.top).padding(.bottom, 5)
            Text("Arrival uses your location to automatically determine the closest station to you. Your location never leaves the device and isn't shared with anyone").font(.caption)
            Spacer()
        }.padding().multilineTextAlignment(.center)
    }
}

struct AuthorizeLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizeLocationView(appState: AppState())
    }
}
