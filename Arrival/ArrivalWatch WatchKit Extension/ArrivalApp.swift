//
//  ArrivalApp.swift
//  ArrivalWatch WatchKit Extension
//
//  Created by Ronan Furuta on 9/29/21.
//

import SwiftUI

@main
struct ArrivalApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
