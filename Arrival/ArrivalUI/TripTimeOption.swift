//
//  TripTimeOption.swift
//  TripTimeOption
//
//  Created by Ronan Furuta on 8/29/21.
//

import SwiftUI
import ArrivalCore

public struct TripTimeOption: View {
    let tripTime: TripTime
    let choose: (TripTime)->()
    let size: Double
    let timeMode: TimeDisplayType
    public init(_ tripTime: TripTime, choose: @escaping (TripTime)-> (), size: Double = 60) {
        self.tripTime = tripTime
        self.choose = choose
        self.size = size
        switch tripTime.type {
        case .arrive:
            self.timeMode = .etd
            return
        default:
            self.timeMode = .timeTill
            return
        }
    }
   public var body: some View {
       Button(action: {choose(self.tripTime)}) {
        
            TimeDisplayText(self.tripTime.time, mode: self.timeMode).foregroundColor(Color("TextColor"))
           
       }.frame(width: size, height: 20).padding().cornerRadius(10).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).foregroundColor(Color("TextColor")).overlay(VStack {
            Spacer()
            if (self.tripTime.type == .now && false) {
            Text("(realtime)")
                    .font(.system(size: 10)).foregroundColor(Color.gray).multilineTextAlignment(.center)
            }
        }.padding(.bottom))
       
    }
}

struct TripTimeOption_Previews: PreviewProvider {
    static var previews: some View {
      
        TripTimeOption(TripTime(type: .now, time: Date(timeIntervalSinceNow: 500)), choose: {time in}).previewLayout(.sizeThatFits).padding()
          /*  TripTimeOption(tripTime: TripTime(type: .leave, time: Date(timeIntervalSinceNow: 5000))).previewLayout(.sizeThatFits).padding()
            TripTimeOption(tripTime: TripTime(type: .arrive, time: Date(timeIntervalSinceNow: 5000*3))).previewLayout(.sizeThatFits).padding()*/
        
       
    }
}
