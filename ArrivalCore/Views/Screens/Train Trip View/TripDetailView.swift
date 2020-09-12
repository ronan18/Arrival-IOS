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
    @State var share = false
    @State var shareActionSheet = false
    @State var shareLink: URL? = nil
    var trip: Trip
    var close: (()->())
    var stations: StationStorage
    var transfers: [TimeInterval] = []
    var bottomPadding: CGFloat = 75
    var linkService: LinkService
    init(trip: Trip, close: @escaping (()->()), stations: StationStorage, linkService: LinkService? = nil) {
        print("TRIP DETAIL: INT", trip.origin.name)
        self.trip = StationService().fillOutStations(forTrip: trip, stations: stations)
        print("TRIP DETAIL: filled out stations")
        self.close = close
        self.stations = stations
        for i in 0..<trip.legs.count {
            if (!trip.legs[i].finalLeg) {
                self.transfers.append(getTimeDifference(from: trip.legs[i].destinationTime, to: trip.legs[i + 1].originTime))
            }
            
        }
        print("TRIP DETAIL: got transfers")
        if #available(iOS 14.0, *) {
            // modern code
            bottomPadding = 130
        } else {
            // Fallback on earlier versions
            bottomPadding = 75
        }
        self.linkService = linkService ?? LinkService()
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
                        Spacer().frame(height: geometry.safeAreaInsets.bottom + self.bottomPadding)
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
                            
                            StyledButton(action: {
                                self.shareActionSheet = true
                                
                            }, text: "SHARE TRIP")
                        }.padding(.bottom, geometry.safeAreaInsets.bottom).padding()
                        
                        
                    }.frame(height: geometry.safeAreaInsets.bottom + self.bottomPadding)
                    
                }
            }.edgesIgnoringSafeArea(.bottom).actionSheet(isPresented: self.$shareActionSheet) {
                ActionSheet(title: Text("Choose how you want to share your trip"), message: Text("By ETA at destination: 5:00 ETA at Rockridge Station. \nBy ETD of train: 10min untill Antioch train at Balboa Park."), buttons: [.default(Text("ETA at destination"), action: {
                    let link = self.linkService.generateLinkForTrip(trip: self.trip, mode: .eta)
                    print("SHARE:",link)
                    self.shareLink = link
                    self.share = true
                }), .default(Text("ETD of train"), action: {
                    let link = self.linkService.generateLinkForTrip(trip: self.trip, mode: .etd)
                    print("SHARE:",link)
                    self.shareLink = link
                    self.share = true
                }),.cancel()])
            }.sheet(isPresented: self.$share) {
                ShareSheet(sharing: [self.shareLink])
            }
        }
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(trip: MockData().trips[0], close: {}, stations: MockData().stationStorage, linkService: LinkService())
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
