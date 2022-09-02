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
        }
    }
    
   
}
extension UIApplication {
    
    static let keyWindow = keyWindowScene?.windows.filter(\.isKeyWindow).first
    static let keyWindowScene = shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    
}

extension View {
    
    func shareSheet(isPresented: Binding<Bool>, items: [Any]) -> some View {
        guard isPresented.wrappedValue else { return self }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in isPresented.wrappedValue = false }
        UIApplication.keyWindow?.rootViewController?.presentedViewController?.present(activityViewController, animated: true)
        return self
    }
    
}
