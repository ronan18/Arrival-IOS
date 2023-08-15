//
//  DestinationBar.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import Foundation
import SwiftUI
import ArrivalCore
public struct DestinationBar: View {
    @EnvironmentObject var appState: AppState
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
                            if (true) {
                        Image(systemName: "location.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 8, height: 8)
                            }
                        }
                        if (self.appState.fromStation == nil) {
                           
                          
                            Text("Choose").font(.headline).lineLimit(1)
                               
                            
                            
                        } else {
                            Text(self.appState.fromStation!.stopName).font(.headline).lineLimit(1)
                           // Text("Station").font(.headline).redacted(reason: .placeholder).lineLimit(1)
                        }
                        
                    }
                    Spacer()
                }
            }.frame(width: navItemWidth)
            Spacer()
            Button(action: {
               // self.appState.timeChooser = true
            }) {
                VStack(alignment:.center) {
                 
                 
                        Text("Now").font(.headline).redacted(reason: .placeholder)
                    
                }
            }.disabled(false).opacity(false ? 0.8 : 1)
            Spacer()
            Button(action: {
             self.appState.toStationChooser = true
               
            }) {
                HStack {
                    Spacer()
                    VStack(alignment:.trailing) {
                        Text("To").font(.caption)
                       
                        Text(self.appState.toStation?.stopName ?? "None").font(.headline).lineLimit(1)
                     
                    }
                }
            }.frame(width: navItemWidth).disabled(false).opacity(false ? 0.8 : 1).frame(width: navItemWidth)
            
            
        }.foregroundColor(Color("LightText")).padding().background(Color("DestinationBar")).sheet(isPresented: self.$appState.fromStationChooser, content: {
            FromStationChooser().environmentObject(self.appState)
        }).sheet(isPresented: self.$appState.toStationChooser, content: {
            ToStationChooser().environmentObject(self.appState)
        })
        
        
    }
}
