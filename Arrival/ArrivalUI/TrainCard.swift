//
//  TrainCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalCore
public struct TrainCard: View {
   // let color: Color
    @Binding var timeDisplayMode: TimeDisplayType
    let train: Train
    let eta: Date?
    let redacted: Bool
    public init( train: Train, timeDisplayMode: Binding<TimeDisplayType>, eta: Date? = nil, redacted: Bool = false) {
       // self.color = Color(train.color.rawValue)
        self.train = train
        self.eta = eta
        self._timeDisplayMode = timeDisplayMode
        self.redacted = redacted
    }
    public var body: some View {
        HStack {
           // Rectangle().frame(width: 10).foregroundColor(self.color)
            HStack {
                VStack(alignment:.leading) {
                    Text("direction").font(.caption)
                    Text(self.train.destinationStation.name).font(.headline).lineLimit(1)
                }
                Spacer()
                if (self.train.cars > 0) {
                VStack(alignment:.trailing) {
                    Text("cars").font(.caption)
                    Text("\(self.train.cars)").font(.headline)
                }
                }
                VStack(alignment:.trailing) {
                    Text("departs").font(.caption)
                    TimeDisplayText(self.train.etd,mode: self.timeDisplayMode)
                }.onTapGesture {
                    switch self.timeDisplayMode {
                    case .etd:
                        self.timeDisplayMode = .timeTill
                        return
                    case .timeTill:
                        self.timeDisplayMode = .etd
                        return
                    }
                }
                if (self.eta != nil) {
                VStack(alignment:.trailing) {
                    Text("arrives").font(.caption)
                    TimeDisplayText(self.eta!,mode: .etd)
                }
                }
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("DarkText"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.redacted ? Color.gray :self.train.colorData); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TrainCard_Previews: PreviewProvider {
    static var previews: some View {
        TrainCard(train: MockUpData().train, timeDisplayMode: .constant(.timeTill)).previewLayout(.sizeThatFits).padding()
    }
}
