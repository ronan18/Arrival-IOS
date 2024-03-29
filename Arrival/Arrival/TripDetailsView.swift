//
//  TripDetailsView.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI
import ArrivalUI
struct TripDetailsView: View {
    @ObservedObject var appState: AppState
    @State var shareText: String = ""
    @State var isPresentingShare = false
    var body: some View {
        if (self.appState.tripDisplay != nil) {
            NavigationView() {
                VStack(spacing: 0) {
                    TripBar(trip: self.appState.tripDisplay!)
                    Divider()
                    List() {
                        TripTransferText(.board, date: self.appState.tripDisplay!.originTime).listRowSeparator(.hidden)
                        ForEach(self.appState.tripDisplay!.legs) {leg in
                            TripCard(leg).listRowSeparator(.hidden)
                            if (!leg.finalLeg) {
                                TripTransferText(.transferWindow, interval: leg.transferWindow).listRowSeparator(.hidden)
                            }
                        }
                        TripTransferText(.arrive, date: self.appState.tripDisplay!.destinationTime).listRowSeparator(.hidden)
                        
                    }.listStyle(.plain)
                    Spacer()
                    
                }.navigationBarTitle("Trip Details").navigationBarItems(trailing:Button(action: {
                    self.appState.diplayTripModal = false
                    self.appState.tripDisplay = nil
                }) {
                    Text("Close")
                }).navigationBarTitleDisplayMode(.automatic).toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        VStack {
         
                           
                            LargeButton("SHARE TRIP", action: {
                                guard let trip = self.appState.tripDisplay else {
                                    return
                                }
                                let shareText = self.appState.generateTripShareText(trip: trip)
                                print(shareText)
                                self.shareText = shareText
                                self.isPresentingShare = true
                                
                            }, haptic: true).shareSheet(isPresented: $isPresentingShare, items: [self.shareText])
                            
                         
                        }.background(.thinMaterial)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView(appState: AppState())
    }
}
