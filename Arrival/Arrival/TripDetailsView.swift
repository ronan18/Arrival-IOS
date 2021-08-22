//
//  TripDetailsView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import ArrivalUI
struct TripDetailsView: View {
    var body: some View {
        NavigationView() {
            VStack(spacing: 0) {
               TripBar()
                Divider()
                List() {
                    TripTransferText().listRowSeparator(.hidden)
                    TripCard(color: .yellow).listRowSeparator(.hidden)
                    TripTransferText().listRowSeparator(.hidden)
                    TripCard(color: .yellow).listRowSeparator(.hidden)
                    TripTransferText().listRowSeparator(.hidden)
                    TripCard(color: .yellow).listRowSeparator(.hidden)
                    TripTransferText().listRowSeparator(.hidden)
                }.listStyle(.plain)
                Spacer()
                
            }.navigationBarTitle("Trip Details").navigationBarItems(trailing:Button(action: {}) {
                Text("Close")
            }).navigationBarTitleDisplayMode(.automatic).toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    VStack {
                       
                    Button(action: {}) {
                        Text("SHARE TRIP").frame(maxWidth: 400).font(.headline)
                            
                    }.tint(.accentColor)
                        .buttonStyle(.bordered)
                        .controlSize(.large).controlProminence(.increased)
                    }.background(.thinMaterial)
                }
            }
        }
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView()
    }
}
