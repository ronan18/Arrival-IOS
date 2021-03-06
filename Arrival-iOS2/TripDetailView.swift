//
//  TripDetailView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 2/16/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Foundation
import FirebaseDynamicLinks
import FirebaseAnalytics
struct TripDetailView: View {
    @Binding var modalShow: Bool
    @Binding var tripToShow: TripInfo
    @State var routeTime = ""
    @State var boardWait = ""
    @State var showShareSheet = false
    @State var shareString = ""
    @State var boarded = false
    @State var shareActionSheet = false
    @State var shareUrl: URL = URL(string:"https://google.com")!
    @EnvironmentObject private var appData: AppData
    func intalize()  {
        
        let originTIme = moment(self.tripToShow.originTime + " " + self.tripToShow.originDate, dateFormateDate)
        let destinationTIme = moment(self.tripToShow.destinatonTime + " " + self.tripToShow.destinatonDate, dateFormateDate)
        self.shareString = destinationTIme.format("h:mma") + " eta at " + self.tripToShow.legs[self.tripToShow.legs.count - 1].destination + " station"
        let routeTime = destinationTIme.diff(originTIme, "minutes")
        let boardTime =  moment(self.tripToShow.legs[0].originTime + " " + self.tripToShow.legs[0].originDate, dateFormate)
        
        self.boardWait =  boardTime.fromNow(true)
        if (boardTime.isSameOrBefore(moment())) {
            self.boarded = true
        }
        
        print(routeTime, destinationTIme.format(), originTIme.format(), "route time", wait)
        self.routeTime = routeTime.stringValue + "  min"
        
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trip Details").font(.largeTitle).fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.modalShow = false
                }) {
                    Text("Close")
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Departs")
                        .font(.caption)
                    Text(timeDisplay(time: self.tripToShow.originTime))
                        .font(.headline)
                }
                Spacer()
                VStack {
                    Text("Travel")
                        .font(.caption)
                    Text(self.routeTime).font(.subheadline).fontWeight(.bold)
                }
                
                
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Arrives")
                        .font(.caption)
                    Text(timeDisplay(time: self.tripToShow.destinatonTime))
                        .font(.headline)
                }
            }.padding([.top, .bottom])
            Divider()
            ScrollView {
                
                
                ForEach(self.tripToShow.legs) {leg in
                    VStack {
                        
                        if (leg.order == 1) {
                            if (self.boarded) {
                                TripWaitTimeView(type: "boarded", time: self.boardWait).padding(.top)
                            } else {
                                TripWaitTimeView(type: "board", time: self.boardWait).padding(.top)
                            }
                        } else {
                            TripWaitTimeView(type: "transfer", time: leg.transferWait ?? "").padding(.top)
                        }
                        
                        TripComponentView(fromStationName: leg.origin, trainName: leg.trainDestination, stops: leg.stops, type: leg.type, destinationStationName: leg.destination, fromStationTime: leg.originTime, toStationTime: leg.destinationTime, enrouteTime: leg.enrouteTime, color: self.appData.convertColor(color: leg.color))
                        if (leg.order == self.tripToShow.legs.count) {
                            TripWaitTimeView(type: "arrive", time: timeDisplay(time:self.tripToShow.destinatonTime))
                        }
                    }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.top, 1)
                }
                
            }
            Spacer()
            Button(action: {
                self.shareActionSheet = true
                
            }) {
                HStack {
                    Spacer()
                    Text("SHARE TRIP")
                        .font(.body)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Spacer()
                }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }.background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).actionSheet(isPresented: $shareActionSheet) {
                ActionSheet(title: Text("Choose how you want to share your trip"), message: Text("By destination: 5:00 ETA at Rockridge Station. \nBy train: 10min untill Antioch train at Balboa Park."), buttons: [.default(Text("ETA at destination"), action: {
                    print("sharing eta at destination")
                    let originTIme = moment(self.tripToShow.originTime + " " + self.tripToShow.originDate, dateFormateDate)
                    let destinationTIme = moment(self.tripToShow.destinatonTime + " " + self.tripToShow.destinatonDate, dateFormateDate)
                    self.shareString = destinationTIme.format("h:mma") + " eta at " + self.tripToShow.legs[self.tripToShow.legs.count - 1].destination + " station"
                    
                    guard let link = URL(string: "https://arrival.city/trip/" + self.tripToShow.tripId) else { return }
                    let dynamicLinksDomainURIPrefix = "https://link.arrival.city"
                    let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
                    linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.ronanfuruta.arrival")
                    linkBuilder!.iOSParameters!.appStoreID = "1497229798"
                    linkBuilder!.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                    linkBuilder!.socialMetaTagParameters!.title = self.shareString
                    linkBuilder!.socialMetaTagParameters!.descriptionText = "Tap to view trip details"
                    linkBuilder!.socialMetaTagParameters!.imageURL = URL(string: "https://arrival.city/images/logo.png")
                    guard let longDynamicLink = linkBuilder!.url else { return }
                    print("The long URL is: \(longDynamicLink)")
                    
                    self.shareUrl = longDynamicLink
                    self.showShareSheet = true
                    Analytics.logEvent("sharing_trip_link", parameters: [
                        "url": longDynamicLink as! NSObject,
                        "type": "destination eta" as! NSObject
                    ])
                    
                }), .default(Text("ETD of train"), action: {
                    print("sharing etd of train")
                    let originTIme = moment(self.tripToShow.originTime + " " + self.tripToShow.originDate, dateFormateDate)
                    let destinationTIme = moment(self.tripToShow.destinatonTime + " " + self.tripToShow.destinatonDate, dateFormateDate)
                    self.shareString = "\(self.boardWait) until \(self.tripToShow.legs[0].trainDestination) train at \(self.tripToShow.legs[0].origin)"
                    print("share string,",  self.shareString)
                    guard let link = URL(string: "https://arrival.city/trip/" + self.tripToShow.tripId) else { return }
                    let dynamicLinksDomainURIPrefix = "https://link.arrival.city"
                    let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
                    linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.ronanfuruta.arrival")
                    linkBuilder!.iOSParameters!.appStoreID = "1497229798"
                    linkBuilder!.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                    linkBuilder!.socialMetaTagParameters!.title = self.shareString
                    linkBuilder!.socialMetaTagParameters!.descriptionText = "Tap to view trip details"
                    linkBuilder!.socialMetaTagParameters!.imageURL = URL(string: "https://arrival.city/images/logo.png")
                    guard let longDynamicLink = linkBuilder!.url else { return }
                    print("The long URL is: \(longDynamicLink)")
                    
                    self.shareUrl = longDynamicLink
                    self.showShareSheet = true
                    Analytics.logEvent("sharing_trip_link", parameters: [
                        "url": longDynamicLink as! NSObject,
                        "type": "train etd" as! NSObject
                    ])
                }), .cancel()])
            }.sheet(isPresented:  $showShareSheet) {
                
                ShareSheet(sharing: [self.shareUrl])
            }
            Spacer().frame(height: 4.0)
            
        }.padding().onAppear {
            
            self.intalize()
            
        }
    }
}

struct TripDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TripDetailView(modalShow: .constant(true), tripToShow: .constant(TripInfo(origin: "", destination: "", legs: [], originTime: "21:00", originDate: "", destinatonTime: "21:30", destinatonDate: "", tripTIme: 0.0, leavesIn: 5, tripId: "test"))).environmentObject(AppData())
    }
}
