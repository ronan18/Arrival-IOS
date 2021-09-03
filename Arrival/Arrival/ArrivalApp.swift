//
//  ArrivalApp.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/20/21.
//

import SwiftUI
import ArrivalCore
import Network
@main
struct ArrivalApp: App {
  
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
        }
    }
}
