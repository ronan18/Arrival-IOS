//
//  AppState.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/24/21.
//

import Foundation
import ArrivalCore
import Combine
import CoreLocation
import SwiftUI
import Intents
import Network

@MainActor
class AppState:NSObject, ObservableObject, CLLocationManagerDelegate {
    //Publishers
    @State var key: String? = nil
    @State var screen: AppScreen = .home
    
    //Services
    let api = ArrivalAPI()
    
    //Constants
    let defaults = UserDefaults.standard
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    //Location state
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
    
    //Watchers
    
    override init() {
        super.init()
        
        
    }
    func startUp() async {
        let key = defaults.string(forKey: "passphrase")
        let lastVersion = defaults.string(forKey: "lastVersion")
        if (lastVersion != version) {
            defaults.setValue(version, forKey: "lastVersion")
        }
        if let key = key {
            //Previously Authorized
            do {
                let auth = try await api.login(auth: key)
                if auth {
                    self.key = key
                } else {
                    runOnboarding()
                }
            } catch {
                print(error)
                runOnboarding()
            }
            
        } else {
            //Not authorized
            runOnboarding()
        }
    }
    func runOnboarding() {
        self.screen = .onboard
        
    }
    
    
}
