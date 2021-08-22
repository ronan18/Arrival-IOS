//
//  DestinationBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

struct DestinationBar: View {
    var body: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                VStack(alignment:.leading) {
                    Text("From").font(.caption)
                    Text("Station").font(.headline)
                }
            }
            Spacer()
            Button(action: {}) {
                VStack(alignment:.center) {
                    Text("leave").font(.caption)
                    Text("Now").font(.headline)
                }
            }
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                VStack(alignment:.trailing) {
                    Text("To").font(.caption)
                    Text("Station").font(.headline)
                }
            }
           
        }.foregroundColor(Color("OppositeTextColor")).padding().background(.black)
    }
}

struct DestinationBar_Previews: PreviewProvider {
    static var previews: some View {
        DestinationBar()
    }
}
