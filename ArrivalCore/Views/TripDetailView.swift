//
//  TripDetailView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
struct TripDetailView: View {
    var trip: Trip
    var close: (()->())
    var stations: StationStorage
    var transfers: [TimeInterval] = []
    init(trip: Trip, close: @escaping (()->()), stations: StationStorage) {
        self.trip = StationService().fillOutStations(forTrip: trip, stations: stations)
        
        self.close = close
        self.stations = stations
        for i in 0..<trip.legs.count {
            if (!trip.legs[i].finalLeg) {
                 self.transfers.append(getTimeDifference(from: trip.legs[i].destinationTime, to: trip.legs[i + 1].originTime))
            }
           
        }
    }
    var body: some View {
        ZStack {
            GeometryReader { geometry in
            
            
            VStack{
                HStack() {
                    Text("Trip Details").font(.title).fontWeight(.bold)
                    Spacer()
                    Button(action: self.close) {
                        Text("close")
                    }
                }
                HStack() {
                    TripDetailTimeInfo(label: "Departs", time: displayTime(self.trip.originTime), alignment: .leading)
                    Spacer()
                    TripDetailTimeInfo(label: "Travel",  time: displayTimeInterval(self.trip.tripTime), alignment: .center)
                    Spacer()
                    TripDetailTimeInfo(label: "Arrives", time: displayTime(self.trip.destinationTime), alignment: .trailing)
                }.padding(.top)
                Divider().padding(.bottom, 0)
                ScrollView {
                    TripTransferWindow(type: .board, timeInterval: timeIntervalUntil(self.trip.originTime))
                    ForEach(0..<self.trip.legs.count) {leg in
                         TripLegCard(leg: self.trip.legs[leg])
                        if (!self.trip.legs[leg].finalLeg) {
                           
                            TripTransferWindow(type: .transfer, timeInterval: self.transfers[leg])
                        }
               
                                     
                    }
                    
                    TripTransferWindow(type: .arrive, time: self.trip.legs[self.trip.legs.count - 1].destinationTime)
                    Spacer().frame(height: geometry.safeAreaInsets.bottom + 75)
                }.padding(.vertical, 0)
                Spacer()
                
            }.padding()
            VStack {
                Spacer()
                ZStack {
                   
                    VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
                                   .edgesIgnoringSafeArea(.all)
                   VStack {
                    Rectangle().frame(height: 1).foregroundColor(Color.gray)
                                          Spacer()
                                      }
                    VStack {
                        
                         StyledButton(action: {}, text: "SHARE TRIP")
                    }.padding(.bottom, geometry.safeAreaInsets.bottom).padding()
                   
                  
                    }.frame(height: geometry.safeAreaInsets.bottom + 75)
               
            }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(trip: MockData().trips[0], close: {}, stations: MockData().stationStorage)
    }
}
struct TripLegCard: View {
    var leg: TripLeg
    
    var transferText = "transfer..."
    var enrouteTime: TimeDisplay
    var originTime: TimeDisplay
    var destTime: TimeDisplay
    init(leg: TripLeg) {
        self.leg = leg
    
        if (leg.finalLeg) {
            self.transferText = "destination..."
        }
        self.enrouteTime = displayTimeInterval(leg.enrouteTime)
        self.originTime = displayTime(leg.originTime)
        self.destTime = displayTime(leg.destinationTime)
    }
    var body: some View {
        HStack(){
            Rectangle()
                .frame(width: 10.0)
                .foregroundColor(converTrainColor(self.leg.route.color))
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text(leg.origin)
                            .font(.headline).lineLimit(1)
                        HStack(spacing: 3) {
                            Image(systemName: "arrow.right.circle.fill")
                            Text(leg.trainHeadSTN).lineLimit(1)
                        }.font(.subheadline)
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(originTime.time)
                        Text(originTime.a).font(.caption)
                    }
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text("\(leg.stopCount) stops until \(transferText)").font(.footnote)
                        
                        
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(enrouteTime.time).font(.footnote)
                        Text(enrouteTime.a).font(.caption)
                    }
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text(self.leg.destination).lineLimit(1)
                            .font(.headline)
                        
                        
                    }
                    Spacer()
                    HStack(alignment:.lastTextBaseline, spacing: 0) {
                        Text(destTime.time)
                        Text(destTime.a).font(.caption)
                    }
                }
            }.padding([.vertical,.trailing])
        }.frame(height: 150.0).cornerRadius(10).background(Color("cardBackground")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0)
    }
}

enum TripTransferWindowType {
    case transfer
    case board
    case arrive
}

struct TripTransferWindow: View {
    let type: TripTransferWindowType
    var timeInterval: TimeInterval = TimeInterval(60)
    var time: Date = Date()
    var body: some View {
        HStack {
            if (type == .transfer) {
                Image(systemName: "clock")
                Text("\(displayTimeInterval(timeInterval).time) min transfer window")
            } else if (type == .board) {
                Image(systemName: "hourglass.bottomhalf.fill")
                Text("Board in \(displayTimeInterval(timeInterval).time) minutes")
            } else if (type == .arrive) {
                Image(systemName: "checkmark.circle")
                Text("Arrive by \(displayTime(time).time)\(displayTime(time).a)!")
            }
            
        }.font(.footnote)
    }
}

struct TripDetailTimeInfo: View {
    let label: String
    let time: TimeDisplay
    var alignment: HorizontalAlignment
    var body: some View {
        VStack (alignment: alignment) {
            Text(label)
                .font(.caption)
            HStack(alignment:.lastTextBaseline ,spacing: 0) {
                Text(time.time).font(.headline).fontWeight(.bold)
                Text(time.a).font(.caption)
            }
            
        }
    }
}
