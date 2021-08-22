//
//  TripTransferText.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI

public struct TripTransferText: View {
    public init() {}
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Image(systemName: "clock")
            Text(" Board in 5 minutes")
            Spacer()
        }.font(.caption)
    }
}

struct TripTransferText_Previews: PreviewProvider {
    static var previews: some View {
        TripTransferText()
    }
}
