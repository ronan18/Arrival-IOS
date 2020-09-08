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
import CoreLocation
import FirebasePerformance
import FirebaseAnalytics
import FirebaseRemoteConfig

class AppState:NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var screen: AppScreen = .loading
    @Published var stations: StationStorage? = nil
    @Published var locationAccess = false
    @Published var location: CLLocation? = nil
    @Published var closestStations: [Station] = []
    @Published var fromStation: Station? = nil
    @Published var toStation: Station? = nil
    @Published var tripTimeConfig: TripTimeModel = TripTimeModel(timeMode: .now, time: Date())
    @Published var LocationServicesState: LocationServicesState = .loading
    @Published var toStationSuggestions: [Station] = []
    @Published var fromStationSuggestions: [Station] = []
    @Published var remoteConfig = RemoteConfig.remoteConfig()
    @Published var onBoardingConfig: OnBoardingConfig? = nil
    @Published var configLoaded = false
    var api = ApiService()
    let stationService = StationService()
    let defaults = UserDefaults.standard
    var key: String = ""
    var authorized: Bool = false
    private var toStationEvents: [ToStationEvent] = []
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
    private var goingOffClosestStation = true
    private var fromStationWatcher: Any? = nil
    private var toStationWatcher: Any? = nil
    private let settings = RemoteConfigSettings()
    override init() {
        
        super.init()
        settings.minimumFetchInterval = 43200
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        self.runRemoteConfigFetches()
        remoteConfig.fetch(withExpirationDuration: TimeInterval(43200)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                    DispatchQueue.main.async {
                        
                        self.runRemoteConfigFetches()
                        self.configLoaded = true
                        
                    }
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
        }
        
        let passphrase = defaults.string(forKey: "passphrase")
        if let passphrase = passphrase {
            print("authorized")
            api.login(key: passphrase, handleComplete: {authorized  in
                if (authorized) {
                    print("auth valid")
                    self.key = passphrase
                    self.authorized = true
                    self.fetchToStationEvents()
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
    func runRemoteConfigFetches() {
        self.onBoardingConfig = OnBoardingConfig(welcome: OnBoardingScreenConfig(title: self.remoteConfig["onboarding1Heading"].stringValue!, description: self.remoteConfig["onboarding1Tagline"].stringValue!), lowDataUsage: OnBoardingScreenConfig(title: self.remoteConfig["onboarding2Heading"].stringValue!, description: self.remoteConfig["onboarding2Tagline"].stringValue!), smartDataSuggestions: OnBoardingScreenConfig(title: self.remoteConfig["onboarding3Heading"].stringValue!, description: self.remoteConfig["onboarding3Tagline"].stringValue!), anonymous: OnBoardingScreenConfig(title: self.remoteConfig["onboarding4Heading"].stringValue!, description: self.remoteConfig["onboarding4Tagline"].stringValue!))
    }
    func fetchToStationEvents() {
        do {
            let toStationEvents = try Disk.retrieve("toStationEvents.json", from: .documents, as: [ToStationEvent].self)
            self.toStationEvents = toStationEvents
            print("got toStationEvents from disk", toStationEvents)
        } catch {
            print("erorr retreiving toStationEvents")
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
    func  requestLocation() {
        locationManager.requestWhenInUseAuthorization()
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location updated")
        if let location = locations.first {
            //print(location.coordinate, "location", location)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            self.location = location
            self.getClosestStations()
        }
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        print("location auth status updated")
        switch status {
        case .notDetermined:
            print("location access not determined")
            self.LocationServicesState = .askForLocation
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationAccess = true
                self.LocationServicesState = .loading
                self.getClosestStations()
                print(" location access")
                // Analytics.setUserProperty("true", forName: "locationAccess")
            }
        case .restricted, .denied:
            self.locationAccess = false
            self.LocationServicesState = .askForLocation
            print("no location access")
            // Analytics.setUserProperty("false", forName: "locationAccess")
        }
    }
    func getClosestStations(handleComplete: ((Bool)->())? = nil) {
        if let stations = self.stations {
            if let location = self.location {
                self.stationService.getClosestStations(stations: stations.stations, location: location, handleComplete: { stations in
                    self.closestStations = stations
                    self.fromStationSuggestions =  stations
                    if self.goingOffClosestStation {
                        self.fromStation = stations[0]
                        self.LocationServicesState = .ready
                    }
                    if let handleComplete = handleComplete {
                        handleComplete(true)
                    }
                })
            } else  {
                self.closestStations = stations.stations
                self.fromStationSuggestions =  stations.stations
                
                if let handleComplete = handleComplete {
                    handleComplete(false)
                }
            }
            
        }
        
    }
    func getToStationSuggestions(_ fromStation: Station? = nil, toStation: Station? = nil) {
        let finalFromStation = fromStation ?? self.fromStation
        let finalToStation = toStation ?? self.toStation
        if let fromStation = finalFromStation {
            print("getting to station suggestions for:", fromStation.name)
            self.toStationSuggestions = self.stationService.getToStationSuggestions(fromStation: fromStation, previousRequests: self.toStationEvents, stations: self.stations!, currentToStation: toStation)
        }
        
        
    }
    
    func start() {
        
        print("start")
        self.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            print("location access after start")
        } else {
            print("no location access")
            self.fromStationSuggestions = self.stations?.stations ?? []
            self.LocationServicesState = .askForLocation
            self.requestLocation()
            
        }
        self.fromStationWatcher = self.$fromStation.sink { value in
            print("from station change", value)
            if let station = value {
                self.getToStationSuggestions(station, toStation: self.toStation)
            }
        }
        self.toStationWatcher = self.$toStation.sink { value in
            print("to station change", value)
            if let station = value {
                self.getToStationSuggestions(self.fromStation, toStation: value)
            }
        }
        self.getClosestStations(handleComplete: { success in
            if (success) {
                self.LocationServicesState = .ready
            }
            self.screen = .home
            
        })
        
    }
    func chooseToStation(_ station: Station?) {
        
        self.toStation = station
        let time = Date()
        if let station = station {
            let fromStation = self.fromStation
            let newEvent = ToStationEvent(fromStation: fromStation!, toStation: station, time: time)
            self.toStationEvents.append(newEvent)
            do {
                try Disk.append(newEvent, to: "toStationEvents.json", in: .documents)
            } catch {
                print("error saving toStationEvent")
            }
            
        }
    }
}
