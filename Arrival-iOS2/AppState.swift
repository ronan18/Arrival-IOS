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
import FirebaseDynamicLinks
import SwiftUI
import CoreHaptics
import UIKit
import Intents

enum StationChooserBarState {
    case loading
    case choose
    case ready
}

class AppState:NSObject, ObservableObject, CLLocationManagerDelegate {
    //MARK: Publishers
    @Published var screen: AppScreen = .loading
    @Published var stations: StationStorage? = nil
    @Published var locationAccess = false
    @Published var location: CLLocation? = nil
    @Published var closestStations: [Station] = []
    @Published var fromStation: Station? = nil
    @Published var toStation: Station? = nil
    @Published var tripTimeConfig: TripTimeModel = TripTimeModel(timeMode: .now, time: Date())
    @Published var locationServicesState: LocationServicesState = .loading
    @Published var toStationSuggestions: [Station] = []
    @Published var fromStationSuggestions: [Station] = []
    @Published var remoteConfig = RemoteConfig.remoteConfig()
    @Published var onBoardingConfig: OnBoardingConfig? = nil
    @Published var configLoaded = false
    @Published var bannerAlert: AlertConfig? = nil
    @Published var stationChooserBarState: StationChooserBarState = .loading
    @Published var key: String = ""
    @Published  var toStationEvents: [ToStationEvent] = []
    @Published var cycleTimer: Double = 30
    @Published var trains: [Train]? = nil
    @Published var trips: [Trip]? = nil
    @Published var goingOffClosestStation = true
    @Published var linkedTripState: LinkedTripState = .loading
    @Published var linkedTrip: Trip? = nil
    @Published var linkedTripShown = false
    @Published var toStationFromIntent: IntentStation? = nil
    var api = ApiService()
    let stationService = StationService()
    let defaults = UserDefaults.standard
    
    var authorized: Bool = false
    
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
     
    private var fromStationWatcher: Any? = nil
    private var toStationWatcher: Any? = nil
    private var locationServiceStatusWatcher: Any? = nil
    private let settings = RemoteConfigSettings()
    private let timeService = TimeService()
    private let trainService = TrainsService()
    let linkService = LinkService()
    //MARK: Initilization
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
            self.fromStationSuggestions = stations.stations
            print("got stations from cache")
        } catch {
            self.fetchStations()
        }
    }
    // MARK: Fetch data stores
    func runRemoteConfigFetches() {
        self.onBoardingConfig = OnBoardingConfig(welcome: OnBoardingScreenConfig(title: self.remoteConfig["onboarding1Heading"].stringValue!, description: self.remoteConfig["onboarding1Tagline"].stringValue!), lowDataUsage: OnBoardingScreenConfig(title: self.remoteConfig["onboarding2Heading"].stringValue!, description: self.remoteConfig["onboarding2Tagline"].stringValue!), smartDataSuggestions: OnBoardingScreenConfig(title: self.remoteConfig["onboarding3Heading"].stringValue!, description: self.remoteConfig["onboarding3Tagline"].stringValue!), anonymous: OnBoardingScreenConfig(title: self.remoteConfig["onboarding4Heading"].stringValue!, description: self.remoteConfig["onboarding4Tagline"].stringValue!))
        self.cycleTimer = Double(self.remoteConfig["cycleTimer"].stringValue!)!
        if let alertContent = self.remoteConfig["inAppMessage"].stringValue {
            if (alertContent.count > 1) {
                var link: URL? = nil
                if let linkString = self.remoteConfig["inAppLink"].stringValue {
                    link = URL(string: linkString)
                }
                self.bannerAlert = AlertConfig(content: alertContent, link: link)
            }
        }
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
            self.fromStationSuggestions = stationData.stations
            
        })
    }
    func deleteToStationEvents() {
        self.toStationEvents = []
        do {
            try Disk.remove("toStationEvents.json", from: .documents)
        } catch {
            
        }
        self.getToStationSuggestions()
    }
    // MARK: Account logic
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
    
    
    // MARK: Location delegates
    func  requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  print("LOCATION: update")
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
            self.locationServicesState = .askForLocation
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationAccess = true
                self.locationServicesState = .loading
                self.getClosestStations()
                print(" location access")
                // Analytics.setUserProperty("true", forName: "locationAccess")
            }
        case .restricted, .denied:
            self.locationAccess = false
            self.locationServicesState = .askForLocation
            print("no location access")
            // Analytics.setUserProperty("false", forName: "locationAccess")
        }
    }
    
    
    func getClosestStations(handleComplete: ((Bool)->())? = nil) {
            print("LOCATION STATION: refresh closest station")
        if let stations = self.stations {
            if let location = self.location {
                self.stationService.getClosestStations(stations: stations.stations, location: location, handleComplete: { stations in
                    self.closestStations = stations
                    self.fromStationSuggestions =  stations
                    if self.goingOffClosestStation {
                        print("LOCATION: going off closest station", stations[0].name, self.fromStation?.name)
                        self.fromStation = stations[0]
                        self.locationServicesState = .ready
                        self.cylce()
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
            
        } else {
            if let handleComplete = handleComplete {
                handleComplete(false)
            }
        }
        
    }
    // MARK: Suggestions Proiders
    func getToStationSuggestions(_ fromStation: Station? = nil, toStation: Station? = nil) {
        let finalFromStation = fromStation ?? self.fromStation
        let finalToStation = toStation ?? self.toStation
        if let fromStation = finalFromStation {
            print("getting to station suggestions for:", fromStation.name)
            self.toStationSuggestions = self.stationService.getToStationSuggestions(fromStation: fromStation, previousRequests: self.toStationEvents, stations: self.stations!, currentToStation: toStation)
        }
        
        
    }
    func getTimeSuggestions(fromStation: Station, toStation: Station?) {
        print("getting time suggestions")
        let suggestions =  self.timeService.suggestTimes(fromStation: fromStation, toStation: toStation, time: Date())
    }
    func checkForIntent() {
        print("SIRI: check for intent")
        if let toStationIntent = self.toStationFromIntent {
            let stationAbbr = convertIntentToStation(toStationIntent)
            if let stationAbbr = stationAbbr {
                print("SIRI: Station ABRR from siris", stationAbbr)
                
                guard let toStation = self.stations?.byAbbr[stationAbbr] else {
                    return
                }
                self.toStation = toStation
                self.trips = nil
                self.trains = nil
                self.toStationFromIntent = nil
            }
            
        }
    }
    // MARK: Start function
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
            self.locationServicesState = .askForLocation
            self.requestLocation()
            
        }
        self.fromStationWatcher = self.$fromStation.sink { value in
            print("from station change", value)
            if let station = value {
                self.getToStationSuggestions(station, toStation: self.toStation)
                self.getTimeSuggestions(fromStation: station, toStation: self.toStation)
            }
            self.checkForIntent()
        }
        self.locationServiceStatusWatcher = self.$locationServicesState.sink {value in
            
        }
        self.toStationWatcher = self.$toStation.sink { value in
            print("to station change", value)
            if let station = value {
                self.getToStationSuggestions(self.fromStation, toStation: value)
                self.getTimeSuggestions(fromStation: self.fromStation!, toStation: station)
            }
        }
        self.getClosestStations(handleComplete: { success in
            if (success) {
                self.locationServicesState = .ready
            }
            
            self.screen = .home
        })
        self.cylce()
        Timer.scheduledTimer(withTimeInterval: self.cycleTimer, repeats: true) { timer in
            self.cylce()
        }
        self.checkForIntent()
        
    }
    // MARK: Dynamic link handleing
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        print("LINK: handled link", dynamicLink.url )
        self.linkedTripState = .loading
        self.linkedTripShown = true
               if let url = dynamicLink.url {
                   let tripId = (url.absoluteString as NSString).lastPathComponent
                   print("LINK:  trip id handled link", tripId)
                api.getTrip(byID: tripId, handleComplete: {trip in
                    if let trip = trip {
                        self.linkedTrip = trip
                        self.linkedTripState = .ready
                    } else {
                         self.linkedTripState = .expired
                    }
                })
                  
               }
        
    }
    
    // MARK: Choose stations
    func chooseFromStation(_ station: Station) {
        self.trains = nil
              self.trips = nil
        self.fromStation = station
           self.buttonHaptics()
        if (station == closestStations[0]) {
            self.goingOffClosestStation = true
        } else {
            self.goingOffClosestStation = false
        }
     
        self.cylce()
    }
    func chooseToStation(_ station: Station?) {
        self.trains = nil
        self.trips = nil
        self.toStation = station
               self.buttonHaptics()
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
        self.cylce()
        let intent = TrainsToStationIntent()
        intent.destination = convertToIntent(station ?? Station(id: "", name: "", abbr: ""))
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: {response in
            print("SIRI:", response)
        })
    
    }
    
    //MARK: Station Cycle
    
    @objc func cylce() {
        self.checkForIntent()
        print("cycle: starting cycle")
        if (self.fromStation != nil && self.api.authorized) {
            print("cycle: allowed to cycle")
            if (self.toStation == nil) {
                self.trips = nil
                print("cycle: train mode")
                self.api.getTrainsFrom(from: self.fromStation!, timeConfig: self.tripTimeConfig, handleComplete: {trains in
                    //    print("cycle: train response", trains)
                    if let trains = trains {
                        self.trains = self.trainService.sortTrains(trains)
                    } else {
                        self.trains = []
                        
                    }
                    
                })
            } else {
                self.trains = nil
                print("cycle: route mode")
                self.api.getTrips(from: self.fromStation!, to: self.toStation!, timeConfig: self.tripTimeConfig, handleComplete: {trips in
                    
                    if let trips = trips {
                        self.trips = self.trainService.sortTrips(trips)
                    } else {
                        self.trips = []
                        
                    }
                    //print("cycle: route response", trips)
                })
            }
        } else {
            print("cycle: cycle not allowed")
        }
        print("cycle: end cycle")
        
    }
    
    func buttonHaptics() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                          impactMed.impactOccurred()
    }
    
}
