//
//  StationCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
public struct StationCard: View {
    @ObservedObject var appState: AppState
    let station: Station
    @State var walkingTime: Date? = nil
    @State var distance: Double? = nil
    @State var loadingDistance = true
  
    public var body: some View {
        HStack {
            
            HStack {
                Text(station.name).font(.headline).lineLimit(1)
                Spacer()
                if (self.walkingTime != nil) {
                    VStack(alignment:.trailing) {
                        Text("walking time").font(.caption)
                        TimeDisplayText(self.walkingTime!, mode: .timeTill)
                    }
                } else  if (self.distance != nil) {
                    VStack(alignment:.trailing) {
                        Text("distance").font(.caption)
                        Text("\(String(distance!))mi").bold()
                    }
                
                }else if (self.loadingDistance) {
                    VStack(alignment:.trailing) {
                        Text("walking distance").font(.caption).redacted(reason: .placeholder)
                        TimeDisplayText(Date(), mode: .timeTill).redacted(reason: .placeholder)
                    }
                }
                
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("DarkText"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).task {
            if( self.loadingDistance) {
                let number = Double.random(in: 0..<1)
                await Task.sleep(UInt64(number) * 1_000_000_000)
                let time = await self.appState.mapService.walkingTimeTo(self.station)
                if let time = time {
                    self.walkingTime = time
                } else {
                    let distance = await self.appState.mapService.distanceTo(self.station)
                    self.distance = distance
                    self.loadingDistance = false
                }
            }
        }
    }
}

struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard(appState: AppState(), station: MockUpData().station)
    }
}
