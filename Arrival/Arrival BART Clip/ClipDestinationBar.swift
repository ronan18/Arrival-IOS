//
//  ClipDestinationBar.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct ClipDestinationBar: View {
    @ObservedObject var appState: AppClipState
    let navItemWidth: Double = 125
    public var body: some View {
        
        HStack {
            Button(action: {
                self.appState.fromStationChooser = true
            }) {
                HStack {
                    
                    VStack(alignment:.leading, spacing: 0) {
                        HStack(spacing: 5) {
                            Text("From").font(.caption)
                            if (self.appState.goingOffOfClosestStation && self.appState.locationAuthState == .authorized) {
                                Image(systemName: "location.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 8, height: 8)
                            }
                        }
                        if (self.appState.fromStation != nil || self.appState.locationAuthState == .notAuthorized) {
                            
                            
                            Text(self.appState.fromStation?.name ?? "Choose").font(.headline).lineLimit(1)
                            
        
                            
                        } else {
                            Text("Station").font(.headline).redacted(reason: .placeholder).lineLimit(1)
                        }
                        
                    }
                    Spacer()
                }
            }.sheet(isPresented: .init(get: {
                return self.appState.fromStationChooser
            }, set: {
                self.appState.fromStationChooser = $0
            })) {
                 ClipStationSearchView(appState: self.appState)
            }
            Spacer()
            
            
        }.foregroundColor(Color("LightText")).padding().background(Color("DestinationBar"))
        
        
    }
}

struct ClipDestinationBar_Previews: PreviewProvider {
    static var previews: some View {
        ClipDestinationBar(appState: AppClipState())
    }
}
