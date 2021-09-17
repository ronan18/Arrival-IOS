//
//  BARTAlertView.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 9/15/21.
//

import SwiftUI
import ArrivalCore
public struct BARTAlertView: View {
    let alert: BARTAlert
    public init (_ alert: BARTAlert) {
        self.alert = alert
    }
   public var body: some View {
       HStack {
           VStack(alignment:.leading) {
               if (alert.station.count > 1) {
            Text(alert.station).font(.headline)
                   Text(alert.description).font(.subheadline)
               } else {
                   Text(alert.description).font(.headline)
               }
           
        }.padding().foregroundColor(Color("TextColor"))
           Spacer()
       }.cornerRadius(10).background(Color("CardBG")).overlay(
        RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
    ).cornerRadius(10.0)
    }
}

struct BARTAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BARTAlertView(BARTAlert(station: "test", description: "test"))
    }
}
