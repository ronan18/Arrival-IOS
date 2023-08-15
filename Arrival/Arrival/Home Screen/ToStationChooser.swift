//
//  ToStationChooser.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/12/23.
//

import Foundation

import SwiftUI

struct ToStationChooser: View {
    @EnvironmentObject var appState: AppState
    @State var search: String = ""
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    Task {
                        self.appState.toStationChooser = false
                        await self.appState.setToStation(nil)
                       
                    }
                }) {
                    HStack {
                        
                        HStack {
                            Text("none").font(.headline).lineLimit(1)
                            Spacer()
                        }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
                    }.cornerRadius(10).background(Color("CardBG")).overlay(
                        RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
                    ).cornerRadius(10.0)
                }.listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                ForEach(self.appState.toStationSuggestions.filter({station in
                    guard search.count >= 1 else {
                        return true
                    }
                    return station.stopName.lowercased().contains(search.lowercased())
                })) {station in
                    Button(action: {
                        Task {
                            self.appState.toStationChooser = false
                            await self.appState.setToStation(station)
                           
                        }
                    }) {
                        StationCard(station: station).environmentObject(appState)
                    }.listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                   
                }
            }.padding(.horizontal).navigationTitle("To Station").searchable(text: self.$search).listStyle(.plain).navigationBarItems(trailing:Button(action: {
                self.appState.toStationChooser = false
            }) {
                Text("Close").foregroundColor(Color("TextColor"))
            }).navigationBarTitleDisplayMode(.large)
        }
    }
}

