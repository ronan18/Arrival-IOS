//
//  DestinationBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct DestinationBar: View {
    @ObservedObject var appState: AppState
    let navItemWidth: Double = 150
    public var body: some View {
        
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                HStack {
                    
                    VStack(alignment:.leading) {
                        Text("From").font(.caption)
                        if (self.appState.fromStation != nil || self.appState.locationAuthState == .notAuthorized) {
                            Text(self.appState.fromStation?.name ?? "Choose").font(.headline).lineLimit(1)
                        } else {
                            Text("Station").font(.headline).redacted(reason: .placeholder).lineLimit(1)
                        }
                        
                    }
                    Spacer()
                }
            }.frame(width: navItemWidth)
            Spacer()
            Button(action: {}) {
                VStack(alignment:.center) {
                    Text("leave").font(.caption)
                    if (self.appState.locationAuthState == .notAuthorized) {
                        Text("Now").font(.headline).lineLimit(1)
                    }else if (self.appState.fromStation != nil) {
                        Text("Now").font(.headline)
                    } else {
                        Text("Now").font(.headline).redacted(reason: .placeholder)
                    }
                }
            }.disabled(self.appState.fromStation == nil).opacity(self.appState.fromStation == nil && self.appState.locationAuthState == .notAuthorized ? 0.8 : 1)
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                HStack {
                    Spacer()
                    VStack(alignment:.trailing) {
                        Text("To").font(.caption)
                        if (self.appState.locationAuthState == .notAuthorized) {
                            Text("None").font(.headline).lineLimit(1)
                        }else if (self.appState.fromStation != nil) {
                            Text("\(self.appState.toStation?.name ?? "None")").font(.headline).lineLimit(1)
                        } else {
                            Text("Station").font(.headline).redacted(reason: .placeholder).lineLimit(1)
                        }
                    }
                }
            }.frame(width: navItemWidth).disabled(self.appState.fromStation == nil).opacity(self.appState.fromStation == nil && self.appState.locationAuthState == .notAuthorized ? 0.8 : 1)
            
        }.foregroundColor(Color("OppositeTextColor")).padding().background(.black)
        
        
    }
}

struct DestinationBar_Previews: PreviewProvider {
    static var previews: some View {
        DestinationBar(appState: AppState())
    }
}
