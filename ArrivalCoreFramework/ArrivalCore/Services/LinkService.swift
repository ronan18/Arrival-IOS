//
//  LinkService.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/9/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
import FirebaseAnalytics
enum TripLinkMode {
    case etd
    case eta
}
class LinkService {
    func generateLinkForTrip(trip: Trip, mode: TripLinkMode) -> URL {
        var linkTitle: String
        switch mode {
        case .eta:
            let time = displayTime(trip.destinationTime)
            linkTitle = "\(time.time) \(time.a) eta at \(trip.destination.name) station"
        case .etd:
            //let trainColor = converTrainColorToHuman(trip.legs[0].route.color) + " line"
            let trainColor = trip.legs[0].trainHeadSTN
            let time = displayMinutesString(trip.originTime)
            switch time.etdMode {
            case .time:
                  linkTitle = "\(time.time) \(time.a) etd for \(trainColor) train at \(trip.origin.name) station"
            case .now:
                  linkTitle = "depart now for \(trainColor) train at \(trip.origin.name) station"
            case .min:
               linkTitle = "\(time.time) \(time.a) until \(trainColor) train at \(trip.origin.name) station"
            }
           
            
        }
        let link = URL(string: "https://arrival.city/trip/" + trip.id)!
        let dynamicLinksDomainURIPrefix = "https://link.arrival.city"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.ronanfuruta.arrival")
        linkBuilder!.iOSParameters!.appStoreID = "1497229798"
        linkBuilder!.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder!.socialMetaTagParameters!.title = linkTitle
        linkBuilder!.socialMetaTagParameters!.descriptionText = "Tap to view trip details"
        linkBuilder!.socialMetaTagParameters!.imageURL = URL(string: "https://arrival.city/images/logo.png")
        guard let longDynamicLink = linkBuilder!.url else {
            return link
        }
        print("LINK SERVICE: The long URL is: \(longDynamicLink)")
        Analytics.logEvent("sharing_trip_link", parameters: ["mode": mode])
        return longDynamicLink
    }
}
