//
//  ArrivalApp.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/20/21.
//

import SwiftUI
import ArrivalCore
import Network
import Intents
@main
struct ArrivalApp: App {
    @Environment(\.scenePhase) private var scenePhase
  //  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var width: CGFloat?
    init() {
       // NetworkActivityIndicatorManager.shared.isEnabled = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = 700
            print("on mac",  UIDevice.current.systemName)
        } else {
            print("not mac")
            debugPrint(UIDevice.current.systemName)
            width = nil
        }
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { phase in
            INPreferences.requestSiriAuthorization({status in
            // Handle errors here
               
        })
    }
    }
   
}
