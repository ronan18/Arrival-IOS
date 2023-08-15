//
//  StationCard.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/15/23.
//

import SwiftUI
import ArrivalGTFS
import ArrivalCore
struct StationCard: View {
    @EnvironmentObject var appState: AppState
    @State var routes: [Route] = []
    var station: Stop
    
    var body: some View {
        HStack {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(station.stopName).font(.headline).lineLimit(1)
                    HStack(spacing: 0) {
                        ForEach(routes) {route in
                            Circle().frame(width: 10, height: 10).foregroundColor(Color(bartColor: route.routeColor)).padding(.trailing, 2)
                        }
                    }.padding(.top, 2)
                }
                Spacer()
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).task {
            let res = await ArrivalDataManager.shared.route(stopId: station.stopId)
            var colors: [String] = []
            withAnimation {
                self.routes = res.filter({route in
                    guard colors.contains(route.routeColor ?? "") else {
                        colors.append(route.routeColor ?? "")
                        return true
                    }
                    return false
                })
               
            }
        }
        
        
    }
}

/*struct StationCard_Previews: PreviewProvider {
    static var previews: some View {
        StationCard()
    }
}
*/
