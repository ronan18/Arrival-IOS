//
//  TrainView.swift
//  ArrivalWatchUI
//
//  Created by Ronan Furuta on 9/29/21.
//

import SwiftUI
import ArrivalWatchCore

public struct TrainView: View {
    let train: Train
    @Binding var timeDisplayMode:TimeDisplayType
    let redacted: Bool
    public init( train: Train,timeDisplayMode: Binding<TimeDisplayType>, redacted: Bool = false) {
       // self.color = Color(train.color.rawValue)
        self.train = train
        self._timeDisplayMode = timeDisplayMode
        self.redacted = redacted
    }
    public var body: some View {
        HStack {
            HStack {
                VStack(alignment:.leading) {
                   // Text("direction").font(.caption)
                    Text(self.train.destinationStation.name).font(.headline).lineLimit(1)
                }
                Spacer()
                if (self.train.cars > 0  && false) {
                VStack(alignment:.trailing) {
                    Text("cars").font(.caption)
                    Text("\(self.train.cars)").font(.headline)
                }
                }
                VStack(alignment:.trailing) {
                    //Text("departs").font(.caption)
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
              
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.redacted ? Color.gray :self.train.colorData); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainView(train: MockUpData().train, timeDisplayMode: .constant(.timeTill))
    }
}
