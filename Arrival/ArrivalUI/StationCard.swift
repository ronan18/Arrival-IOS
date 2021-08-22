//
//  StationCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

struct StationCard: View {
    var body: some View {
        HStack {
           
            HStack {
                Text("Station Name").font(.headline)
                Spacer()
                VStack(alignment:.trailing) {
                    Text("walking distance").font(.caption)
                    TimeDisplayText()
                }
                    
            }.padding(.leading, 20).padding([.vertical,.trailing])
        }.cornerRadius(10).background(Color("CardBG")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard()
    }
}
