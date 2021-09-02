//
//  TripCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalCore

public struct TripCard: View {
    let leg: TripLeg
    @State private var isStopsExpanded: Bool = false
    public init(_ leg: TripLeg) {
        self.leg = leg
    }
    public var body: some View {
        HStack {
            
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(self.leg.origin).font(.headline).lineLimit(1).foregroundColor(Color("DarkText"))
                        HStack(alignment: .center, spacing: 0) {
                            Image(systemName: "arrow.right.circle.fill").foregroundColor(Color("DarkText"))
                            Text(self.leg.trainHeadSTN).lineLimit(1).foregroundColor(Color("DarkText"))
                        }.font(.subheadline)
                        
                    }
                    Spacer()
                    TimeDisplayText(self.leg.originTime, mode: .etd, font: .body)
                }.padding(.bottom)
                HStack(alignment: .firstTextBaseline) {
                    
                    VStack(alignment: .leading) {
                        Button(action: {self.isStopsExpanded.toggle()}) {
                            HStack(spacing: 0) {
                                Image(systemName: self.isStopsExpanded ? "chevron.down" :"chevron.right").padding(.trailing, self.isStopsExpanded ? 5 : 10)
                                Text("\(self.leg.route.stationCount) stops before transfer...")
                            }.font(.footnote).foregroundColor(Color("DarkText")).accentColor(Color("DarkText"))
                        }
                        if (self.isStopsExpanded) {
                            
                            VStack {
                                ForEach(self.leg.stationsEnRoute, id: \.self) { station in
                                    HStack {
                                        Text(station).font(.caption).foregroundColor(Color("DarkText"))
                                        Spacer()
                                    }
                                }
                            }
                            
                            
                        }
                    }
                    Spacer()
                    TimeDisplayText(Date(), mode: .etd, font: .footnote).padding(.leading).foregroundColor(Color("DarkText"))
                }.padding(.bottom)
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(self.leg.destination).font(.headline).lineLimit(1).foregroundColor(Color("DarkText"))
                        
                        
                    }
                    Spacer()
                    TimeDisplayText(self.leg.destinationTime, mode: .etd, font: .body)
                }
            }.padding(.leading, 20).padding([.vertical,.trailing])
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(turnTrainColorToColor(self.leg.route.color)); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TripCard_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(MockUpData().trip.legs.first!).previewLayout(.sizeThatFits).padding()
    }
}
