//
//  DestinationBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalUI

public struct DestinationBar: View {
    @ObservedObject var appState: AppState
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
                               
                            
                             /*  if (self.appState.goingOffOfClosestStation) {
                                   Image(systemName: "location.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 10, height: 10)
                               }*/
                            
                        } else {
                            Text("Station").font(.headline).redacted(reason: .placeholder).lineLimit(1)
                        }
                        
                    }
                    Spacer()
                }
            }.frame(width: navItemWidth).sheet(isPresented: .init(get: {
                return self.appState.fromStationChooser
            }, set: {
                self.appState.fromStationChooser = $0
            })) {
                StationSearchView(appState: self.appState, mode: .from)
            }
            Spacer()
            Button(action: {
                self.appState.timeChooser = true
            }) {
                VStack(alignment:.center) {
                 
                    Text(self.appState.timeConfig.type == .now || self.appState.timeConfig.type == .leave ? "Leave" : "Arrive" ).font(.caption)
                    if (self.appState.locationAuthState == .notAuthorized) {
                        Text("Now").font(.headline).lineLimit(1)
                    } else if (self.appState.fromStation != nil) {
                        if (self.appState.timeConfig.type == .now) {
                            Text("Now").font(.headline)
                        } else {
                        TimeDisplayText(self.appState.timeConfig.time, mode: .etd)
                        }
                    } else {
                        Text("Now").font(.headline).redacted(reason: .placeholder)
                    }
                }
            }.disabled(self.appState.fromStation == nil).opacity(self.appState.fromStation == nil && self.appState.locationAuthState == .notAuthorized ? 0.8 : 1).sheet(isPresented: .init(get: {
                return self.appState.timeChooser
            }, set: {
                self.appState.timeChooser = $0
            })) {
                TimeChooserView(appState: self.appState)
            }
            Spacer()
            Button(action: {
                self.appState.toStationChooser = true
            }) {
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
            }.frame(width: navItemWidth).disabled(self.appState.fromStation == nil).opacity(self.appState.fromStation == nil && self.appState.locationAuthState == .notAuthorized ? 0.8 : 1).frame(width: navItemWidth).sheet(isPresented: .init(get: {
                return self.appState.toStationChooser
            }, set: {
                self.appState.toStationChooser = $0
            })) {
                StationSearchView(appState: self.appState, mode: .to)
            }
            
        }.foregroundColor(Color("LightText")).padding().background(Color("DestinationBar"))
        
        
    }
}

struct DestinationBar_Previews: PreviewProvider {
    static var previews: some View {
        DestinationBar(appState: AppState())
    }
}
