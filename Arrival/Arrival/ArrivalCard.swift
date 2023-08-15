//
//  ArrivalCard.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/10/23.
//

import SwiftUI
import ArrivalCore
import ArrivalGTFS

struct ArrivalCard: View {
    @EnvironmentObject var appState: AppState
    let arrival: Arrival
    @State var color: Color

    let redacted: Bool = false
    init(arrival: Arrival) {
        self.arrival = arrival
        switch arrival.type {
        case .train(let train):
            self.color = Color(bartColor: train.route.routeColor)
           
        case .tripPlan(let trip):
            self.color = Color(bartColor: trip.connections.first?.startStopTimeId)
        }
    }
    var body: some View {
        HStack {
            Group {
                switch arrival.type {
                case .train(let train):
                    ArrivalTrain(train: train).environmentObject(appState)
                case .tripPlan(let trip):
                    ArrivalPlan(trip: trip).environmentObject(appState)
                }
            }.padding(.leading, 20).padding([.vertical,.trailing]).foregroundColor(Color("TextColor"))
        }.cornerRadius(10).background(Color("CardBG")).overlay(HStack{Rectangle().frame(width: 10).foregroundColor(self.redacted ? Color.gray :color); Spacer()}).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color("CardBorder"), lineWidth:3)
        ).cornerRadius(10.0).task {
            switch arrival.type {
            case .train(_):
                return
               
            case .tripPlan(let trip):
                
                if let firstStopTime = await ArrivalDataManager.shared.stopTime(by: trip.connections.first?.startStopTimeId ?? "") {
                    let trip = await ArrivalDataManager.shared.trip(tripId: firstStopTime.tripId)
                    let route = await ArrivalDataManager.shared.route(id: trip?.routeId ?? "")
                    self.color = Color(bartColor: route?.routeColor)
                }
            }
        }
     
    }
}

/*struct ArrivalCard_Previews: PreviewProvider {
    static var previews: some View {
        ArrivalCard(arrival: Arrival(type: .train(<#T##Train#>)))
    }
}
*/
struct ArrivalPlan: View {
    @EnvironmentObject var appState: AppState
    @State var direction: String = ""
    @State var train: Train? = nil
    let trip: TripPlan
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
               
                    HStack(spacing: 0) {
                        Text("direction ").font(.caption)
                       // Text(train?.stopTime.id ?? "no train")
                        if(self.appState.realtimeStopTimes[train?.stopTime.id ?? ""] != nil) {
                           
                       // Text(String(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)).font(.system(size: 9))
                        Image(systemName: "wifi").font(.system(size: 9))
                            
                        }
                    }
               // Text("id \(train?.stopTime.id ?? "no train")")
               
                Text(self.train?.direction ?? "").font(.headline).lineLimit(1)
            
            }
            Spacer()
            if (self.appState.realtimeTrips[train?.trip.tripId ?? ""] != nil && self.appState.realtimeTrips[train?.trip.tripId ?? ""]?.trainType ?? .unknown != .unknown) {
            VStack(alignment:.trailing) {
                Text("doors").font(.caption)
                switch self.appState.realtimeTrips[train?.trip.tripId ?? ""]!.trainType {
                case .threeDoor:
                    Text("3").font(.headline)
                case .twoDoor:
                    Text("2").font(.headline)
                case .unknown:
                    Text("")
                }
                    
                
              //  Text("\(self.train.cars)").font(.headline)
            }
            }
            VStack(alignment:.trailing) {
             
                    
                    Text("departs").font(.caption)
                if (self.train != nil) {
                if(self.appState.realtimeStopTimes[train?.stopTime.id ?? ""] != nil) {
                    TimeDisplayText(Date(bartTime: self.train!.stopTime.arrivalTime ) + TimeInterval(self.appState.realtimeStopTimes[train!.stopTime.id]?.arrival.delay ?? 0),mode: .etd)
                } else {
                    TimeDisplayText(Date(bartTime: self.train!.stopTime.arrivalTime),mode: .etd)
                }
                } else {
                    TimeDisplayText(self.trip.connections.first?.startTime ?? Date(), mode: .etd)
                }
            }
            VStack(alignment:.trailing) {
             
                    
                    Text("arrives").font(.caption)
               
                    TimeDisplayText(self.trip.connections.last?.endTime ?? Date(), mode: .etd)
                
            }
         
        }.transition(.opacity).task {
            if let firstStopTime = await ArrivalDataManager.shared.stopTime(by: trip.connections.first?.startStopTimeId ?? "") {
                guard let trip = await ArrivalDataManager.shared.trip(tripId: firstStopTime.tripId) else {
                    return
                }
                guard let route = await ArrivalDataManager.shared.route(id: trip.routeId) else {
                    return
                }
                self.train = Train(stopTime: firstStopTime, trip: trip, route: route)
                
            }
        }
    }
}

struct ArrivalTrain: View {
    @EnvironmentObject var appState: AppState
    let train: Train
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
               
                    HStack(spacing: 0) {
                        Text("direction ").font(.caption)
                        if(self.appState.realtimeStopTimes[train.stopTime.id] != nil) {
                           
                       // Text(String(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)).font(.system(size: 9))
                        Image(systemName: "wifi").font(.system(size: 9))
                        }
                    }
                
               
                Text(self.train.direction).font(.headline).lineLimit(1)
            
            }
            Spacer()
            if (self.appState.realtimeTrips[train.trip.tripId] != nil && self.appState.realtimeTrips[train.trip.tripId]?.trainType ?? .unknown != .unknown) {
            VStack(alignment:.trailing) {
                Text("doors").font(.caption)
                switch self.appState.realtimeTrips[train.trip.tripId]!.trainType {
                case .threeDoor:
                    Text("3").font(.headline)
                case .twoDoor:
                    Text("2").font(.headline)
                case .unknown:
                    Text("")
                }
                    
                
              //  Text("\(self.train.cars)").font(.headline)
            }
            }
            VStack(alignment:.trailing) {
             
                    
                    Text("departs").font(.caption)
                
                if(self.appState.realtimeStopTimes[train.stopTime.id] != nil) {
                    TimeDisplayText(Date(bartTime: self.train.stopTime.arrivalTime) + TimeInterval(self.appState.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0),mode: .timeTill)
                } else {
                    TimeDisplayText(Date(bartTime: self.train.stopTime.arrivalTime),mode: .timeTill)
                }
            }
         
        }.transition(.opacity)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
extension Color {
    init(bartColor: String?) {
        switch bartColor {
        case "FFFFFF":
            self.init(.gray)
            return
        case "FFFF33":
            self = Color("DarkYellow")
            return
        /*
        case "339933":
            self.init(.green)
            return */
        case nil:
            self.init(.black)
            return
        default:
           // print("UNSUPPORTED COLOR", bartColor ?? "")
            self.init(hex: bartColor ?? "#ffffff")
            return
        }
    }
}
