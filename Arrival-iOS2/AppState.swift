//
//  AppState.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftyJSON
import Disk
enum AppScreen {
    case loading
    case loadingIndicator
    case home
    case settings
    case onBoarding
}
class AppState: ObservableObject {
    @Published var screen: AppScreen = .loading
    @Published var stations: StationStorage? = nil
    var api = ApiService()
    let defaults = UserDefaults.standard
    var key: String = ""
    var authorized: Bool = false
    init() {
       
        let passphrase = defaults.string(forKey: "passphrase")
        if let passphrase = passphrase {
            print("authorized")
            api.login(key: passphrase, handleComplete: {authorized  in
                if (authorized) {
                    print("auth valid")
                    self.key = passphrase
                    self.authorized = true
                    self.start()
                } else {
                    print("auth invalid")
                    self.screen = .onBoarding
                }
            })
        } else {
            print("no auth")
            self.screen = .onBoarding
        }
        
        do {
        let stations = try Disk.retrieve("stations.json", from: .caches, as: StationStorage.self)
            self.stations = stations
            print("got stations from cache")
        } catch {
            self.fetchStations()
        }
    }
    func createAccount() {
        
        self.screen = .loadingIndicator
        let newKey: String = UUID().uuidString
        
        self.api.createAccount(key: newKey, handleComplete: ({ result  in
            print("created new account", newKey)
            self.api.login(key: newKey, handleComplete: ({ result in
                print("new account validated")
                self.defaults.set(newKey, forKey: "passphrase")
                self.key = newKey
                self.authorized = true
                self.start()
            }))
        }))
        
        
    }
    func logOut() {
        self.defaults.removeObject(forKey: "passphrase")
        self.key = ""
        self.authorized = false
        self.screen = .onBoarding
    }
    func fetchStations() {
          print("fetching stations")
        self.api.getStations(handleComplete: {stationData in
            print("fetched stations")
            do {
                try Disk.save(stationData, to: .caches, as: "stations.json")
                print("saved stations")
            } catch {
                print("error saving stations")
            }
            self.stations = stationData
        })
    }
    func start() {
        print("start")
        
    }
}
