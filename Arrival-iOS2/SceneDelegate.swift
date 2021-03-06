//
//  SceneDelegate.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import UIKit
import SwiftUI
import Foundation
import Combine
import FirebaseCrashlytics
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let appData  = AppData()
    func handleIncomingLink(dynamicLink: DynamicLink) {
        print("handled link", dynamicLink.url )
        if let url = dynamicLink.url {
            let tripId = (url.absoluteString as NSString).lastPathComponent
            print("trip id handled link", tripId)
            appData.dynamicLinkTripId = tripId
            appData.showTripDetailsFromLink(tripId)
        }
        
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the shared persistent container.
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        
        let contentView = ContentView()
        print("incomming link", connectionOptions.userActivities.first?.webpageURL)
        if let link = connectionOptions.userActivities.first?.webpageURL {
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(link) { (dynamiclink, error) in
                if let dynamiclink = dynamiclink {
                    self.handleIncomingLink(dynamicLink: dynamiclink)
                }
            }
        }
        
        
        // Use a UIHostingController as window root view controller.
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(appData))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if let dynamiclink = dynamiclink {
                self.handleIncomingLink(dynamicLink: dynamiclink)
            }
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        appData.net?.stopListening()
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appData.net?.startListening()
        appData.testNetwork()
        // print("cycling from did become active", appData.fromStation)
        //  appData.cylce()
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("cycling from enter forground", appData.fromStation)
        appData.net?.startListening()
        appData.testNetwork()
        appData.cylce()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        appData.net?.stopListening()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

