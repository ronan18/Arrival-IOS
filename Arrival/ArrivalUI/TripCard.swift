//
//  TripCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct TripCard: View {
    let color: Color
    @State private var isStopsExpanded: Bool = false
    public init(color: Color) {
        self.color = color
    }
    public var body: some View {
        HStack {
           
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Boarding Station").font(.headline).lineLimit(1)
                        HStack(alignment: .center, spacing: 0) {
                            Image(systemName: "arrow.right.circle.fill").foregroundColor(Color("TextColor"))
                            Text("Train Direction").lineLimit(1)
                        }.font(.subheadline)
                        
                    }
                    Spacer()
                    TimeDisplayText(Date(), mode: .etd, font: .body)
                }.padding(.bottom)
                HStack(alignment: .firstTextBaseline) {
                    /*DisclosureGroup("11 stops before transfer...", isExpanded: self.$isStopsExpanded) {
                        HStack {
                            Text("Station name").font(.caption)
                            Spacer()
                        }
                    }.font(.footnote).foregroundColor(Color("TextColor")).accentColor(Color("TextColor"))*/
                    VStack(alignment: .leading) {
                    Button(action: {self.isStopsExpanded.toggle()}) {
                        HStack(spacing: 0) {
                            Image(systemName: self.isStopsExpanded ? "chevron.down" :"chevron.right").padding(.trailing, self.isStopsExpanded ? 5 : 10)
                            Text("11 stops before transfer...")
                        }.font(.footnote).foregroundColor(Color("TextColor")).accentColor(Color("TextColor"))
                    }
                    if (self.isStopsExpanded) {
                        HStack {
                            Text("Station name").font(.caption)
                            Spacer()
                        }
                    }
                    }
                    Spacer()
                    TimeDisplayText(Date(), mode: .etd, font: .footnote).padding(.leading)
                }.padding(.bottom)
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Destination Station").font(.headline).lineLimit(1)
                    
                        
                    }
                    Spacer()
                    TimeDisplayText(Date(), mode: .etd, font: .body)
                }
            }.padding(.leading, 20).padding([.vertical,.trailing])
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.color); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TripCard_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(color: .yellow).previewLayout(.sizeThatFits).padding()
    }
}
