//
//  ClipStationCard.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct ClipStationCard: View {
    @ObservedObject var appState: AppClipState
    @AppStorage("displayNavigationTime") var displayNavigationTime = true
    let station: Station
    @State var walkingTime: Date? = nil
    @State var timeLabel: String = "walking"
    @State var distance: Double? = nil
    @State var loadingDistance = true
  
    public var body: some View {
        HStack {
            
            HStack {
                Text(station.name).font(.headline).lineLimit(1)
                Spacer()
                if (self.walkingTime != nil) {
                    VStack(alignment:.trailing) {
                        Text("\(self.timeLabel) time").font(.caption)
                        TimeDisplayText(self.walkingTime!, mode: .timeTill)
                    }
                } else  if (self.distance != nil) {
                    VStack(alignment:.trailing) {
                        Text("distance").font(.caption)
                        Text("\(String(distance!))mi").bold()
                    }
                
                } else if (self.loadingDistance) {
                    VStack(alignment:.trailing) {
                        Text("walking distance").font(.caption).redacted(reason: .placeholder)
                        TimeDisplayText(Date(), mode: .timeTill).redacted(reason: .placeholder)
                    }
                } else {
                    //Text("no distnace")
                }
                
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).task {
            if( self.loadingDistance) {
                if (displayNavigationTime) {
                let number = Double.random(in: 0..<1)
                await Task.sleep(UInt64(number) * 1_000_000_000)
                let (time, text) = await self.appState.mapService.timeTo(self.station)
                if let time = time {
                    self.walkingTime = time
                    self.timeLabel = text
                    self.loadingDistance = false
                } else {
                    let distance = await self.appState.mapService.distanceTo(self.station)
                    self.distance = distance
                    self.loadingDistance = false
                    
                }
                } else {
                    let distance = await self.appState.mapService.distanceTo(self.station)
                    self.distance = distance
                    self.loadingDistance = false
                }
                self.loadingDistance = false
               // print(distance, walkingTime, loadingDistance, "distance")
            }
        }
    }
}

struct ClipStationCard_Previews: PreviewProvider {
    static var previews: some View {
        ClipStationCard(appState: AppClipState(), station: MockUpData().station)
    }
}
