//
//  DestinationBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct DestinationBar: View {
    @ObservedObject var appState: AppState
    
    public var body: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                VStack(alignment:.leading) {
                    Text("From").font(.caption)
                    if (self.appState.fromStation != nil) {
                        Text(self.appState.fromStation?.name ?? "ERROR").font(.headline)
                    } else {
                        Text("Station").font(.headline).redacted(reason: .placeholder)
                    }
                    
                }
            }
            Spacer()
            Button(action: {}) {
                VStack(alignment:.center) {
                    Text("leave").font(.caption)
                    if (self.appState.fromStation != nil) {
                        Text("Now").font(.headline)
                    } else {
                        Text("Now").font(.headline).redacted(reason: .placeholder)
                    }
                }
            }
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                VStack(alignment:.trailing) {
                    Text("To").font(.caption)
                    if (self.appState.fromStation != nil) {
                        Text("Station").font(.headline)
                    } else {
                        Text("Station").font(.headline).redacted(reason: .placeholder)
                    }
                }
            }
            
        }.foregroundColor(Color("OppositeTextColor")).padding().background(.black)
    }
}

struct DestinationBar_Previews: PreviewProvider {
    static var previews: some View {
        DestinationBar(appState: AppState())
    }
}
