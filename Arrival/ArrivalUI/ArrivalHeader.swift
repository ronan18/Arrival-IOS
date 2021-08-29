//
//  ArrivalHeader.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/22/21.
//

import SwiftUI

public struct ArrivalHeader: View {
    public init() {}
    public var body: some View {
        HStack {
            Text("Arrival")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button(action: {}) {
                Image(systemName: "gear")
            }
        }.foregroundColor(.white).padding().background(LinearGradient(gradient: Gradient(colors: [Color("ArrivalBlue"),Color("ArrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct ArrivalHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        ArrivalHeader()
            Spacer()
        }
    }
}
