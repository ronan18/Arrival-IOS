//
//  BARTAlertsScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 9/15/21.
//

import SwiftUI
import ArrivalUI

struct BARTAlertsScreen: View {
    @ObservedObject var appState: AppState
    @Binding var open: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List() {
                    if (self.appState.alerts.count >= 1) {
                        ForEach(self.appState.alerts) {alert in
                            BARTAlertView(alert).listRowSeparator(.hidden).listRowInsets(EdgeInsets()).padding(.vertical, 5)
                        }.listRowSeparator(.hidden).listRowInsets(EdgeInsets())
                    } else {
                        HStack {
                            Spacer()
                        VStack(alignment: .center) {
                            Spacer().frame(height:100)
                            Image(systemName: "clock.badge.checkmark.fill").font(.system(size: 100)).symbolRenderingMode(.hierarchical).padding().foregroundColor(.green)
                            Text("No Delays Reported!").font(.title2).bold().foregroundColor(Color("TextColor"))
                            Text("BART has not reported any issues with train service").foregroundColor(Color("TextColor")).font(.subheadline)
                            Spacer()
                        }
                        Spacer()
                        }.listRowSeparator(.hidden).listRowInsets(EdgeInsets())
                    }
                }.listStyle(.plain).padding().refreshable {
                    await self.appState.refreshAlerts()
                }
            }.navigationBarTitle("Alerts").navigationBarItems(trailing:Button(action: {
                self.open = false
            }) {
                Text("Done").foregroundColor(Color("TextColor"))
            }).navigationBarTitleDisplayMode(.large)
        }
    }
}

struct BARTAlertsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BARTAlertsScreen(appState: AppState(), open: .constant(true))
    }
}
