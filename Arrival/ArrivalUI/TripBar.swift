//
//  TripBar.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI

public struct TripBar: View {
    public init() {}
    public var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text("Departs").font(.caption)
                TimeDisplayText(Date(), mode: .etd)
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Travel").font(.caption)
                TimeDisplayText(Date(), mode: .etd)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Arrives").font(.caption)
                TimeDisplayText(Date(), mode: .etd)
            }
           
        }.padding()
    }
}

struct TripBar_Previews: PreviewProvider {
    static var previews: some View {
        TripBar().previewLayout(.sizeThatFits)
    }
}
