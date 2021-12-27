//
//  ArrivalLegaL.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/26/21.
//

import SwiftUI

public struct ArrivalLegal: View {
    public init () {}
   public var body: some View {
        
       VStack(alignment:.center,spacing: 4) {
            Text("Arrival is created by **[Ronan Furuta](https://ronanfuruta.com/?r=arrivalInApp)**")
                .font(.footnote)
           Text("By using Arrival you agree to \n **[Privacy Policy](https://arrival.city)** and **[Terms of Serivce](https://arrival.city)**").tint(.black)
                .font(.caption2)
        }.multilineTextAlignment(.center)
    }
}

struct ArrivalLegaL_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalLegal()
    }
}
