//
//  TrainCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct TrainCard: View {
    let color: Color
    public init(color: Color) {
        self.color = color
    }
    public var body: some View {
        HStack {
           // Rectangle().frame(width: 10).foregroundColor(self.color)
            HStack {
                VStack(alignment:.leading) {
                    Text("direction").font(.caption)
                    Text("Antioch").font(.headline)
                }
                Spacer()
                VStack(alignment:.trailing) {
                    Text("cars").font(.caption)
                    Text("10").font(.headline)
                }
                VStack(alignment:.trailing) {
                    Text("departs").font(.caption)
                    TimeDisplayText()
                }
                VStack(alignment:.trailing) {
                    Text("arrives").font(.caption)
                   TimeDisplayText()
                }
            }.padding(.leading, 20).padding([.vertical,.trailing])
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.color); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TrainCard_Previews: PreviewProvider {
    static var previews: some View {
        TrainCard(color: .red).previewLayout(.sizeThatFits).padding()
    }
}
