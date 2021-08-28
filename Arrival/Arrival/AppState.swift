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
class AppState: NSObject, ObservableObject, CLLocationManagerDelegate {
    //Publishers
    @Published var key: String? = nil
    @Published var screen: AppScreen = .loading
    
    @Published var locationAuthState = LocationAuthState.notAuthorized
    @Published var locationDataState  = LocationDataSate.notReady
    
    @Published var fromStationSuggestions: [Station] = []
    @Published var goingOffOfClosestStation = true
    
    @Published var fromStation: Station? = nil
    @Published var toStation: Station? = nil
    
    
    @Published var trains: [Train] = []
    //Services
    let api = ArrivalAPI()
    let disk = DiskService()
    let stationService = StationService()
    
    //Constants
    let defaults = UserDefaults.standard
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    //Location state
    private var locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
    private var location: CLLocation? = nil
    
    //stations state
    private var stations: StationStorage? = nil
    private var closestStations: [Station] = []
    
    //Watchers
    
    private var cycleTimerLength: TimeInterval = 500
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        async {
            await self.startUp()
        }
        
    }
    func startUp() async {
        let key = defaults.string(forKey: "passphrase")
        let lastVersion = defaults.string(forKey: "lastVersion")
        if (lastVersion != version) {
            defaults.setValue(version, forKey: "lastVersion")
        }
        
        guard let key = key else {
            runOnboarding()
            return
        }
        
        do {
            let auth = try await api.login(auth: key)
            if auth {
                self.key = key
                await self.startMain()
            } else {
                runOnboarding()
            }
        } catch {
            print(error)
            runOnboarding()
        }
        
    }
    func runOnboarding() {
        self.screen = .onboard
    }
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    func getStations(force: Bool = false) async {
        guard !force else {
            await self.fetchStations()
            return
        }
        if let stations = disk.getStations() {
            self.stations = stations
        } else {
            await self.fetchStations()
        }
    }
    func fetchStations() async {
        do {
            let stations = try await self.api.stations()
            self.stations = stations
            self.disk.saveStations(stations)
        } catch {
            //TODO: Catch this
        }
    }
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("LOCATION: update")
        if let location = locations.first {
            //print(location.coordinate, "location", location)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            self.location = location
            async {
            let _ = await self.getClosestStations()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        //print("location auth status updated")
        switch status {
        case .notDetermined:
            //print("location access not determined")
            self.locationAuthState = .notAuthorized
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationAuthState = .authorized
                //  self.locationServicesState = .loading
                async {
                    await self.getClosestStations()
                }
                //print(" location access")
                // Analytics.setUserProperty("true", forName: "locationAccess")
            }
        case .restricted, .denied:
            self.locationAuthState = .notAuthorized
           // print("no location access")
            // Analytics.setUserProperty("false", forName: "locationAccess")
        @unknown default:
            fatalError()
        }
    }
    func createAccount() async {
        self.screen = .loading
        let newKey: String = "AR-" + UUID().uuidString
        do {
            let result = try await self.api.createAccount(auth: newKey)
            guard result else {
                //TODO: Catch this
                return
            }
            let loginResult = try await self.api.login(auth: newKey)
            
            guard loginResult else {
                //TODO: Catch this
                return
            }
            self.defaults.set(newKey, forKey: "passphrase")
            self.key = newKey
            await self.startMain()
        } catch {
            //TODO: Catch this
        }
        
    }
    func startMain() async {
        print("start main")
        self.screen = .loading
        guard self.key != nil else {
            self.runOnboarding()
            return
        }
        await self.getStations()
        
        
        self.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.startUpdatingLocation()
           // print("location access after start")
            
            //  Analytics.setUserProperty("true", forName: "locationAccess")
        } else {
            //print("no location access")
            // self.fromStationSuggestions = self.stations?.stations ?? []
            self.locationAuthState = .notAuthorized
            // Analytics.setUserProperty("false", forName: "locationAccess")
            self.requestLocation()
            if let firstStation = self.stations?.stations.first {
                self.fromStation = firstStation
            }
            
        }
        
        let _ = await self.getClosestStations()
        
        await self.cycle()
        self.screen = .home
        /*Timer.scheduledTimer(withTimeInterval: self.cycleTimerLength, repeats: true) { timer in
            async {await self.cycle()}
        } */
    }
    func getClosestStations() async -> [Station] {
        print("LOCATION STATION: refresh closest station")
        if let stations = self.stations {
            if let location = self.location {
                let stations =  await self.stationService.getClosestStations(stations: stations.stations, location: location)
                self.closestStations = stations
                self.fromStationSuggestions =  stations
                if self.goingOffOfClosestStation {
                    print("LOCATION: going off closest station", stations[0].name, self.fromStation?.name as Any)
                    self.fromStation = stations[0]
                    // self.locationServicesState = .ready
                    async {
                        await self.cycle()
                    }
                }
                return stations
                
            } else  {
                self.closestStations = stations.stations
                self.fromStationSuggestions =  stations.stations
                
                return stations.stations
            }
            
        } else {
            
            return []
            
            
            
        }
        
    }
    func cycle() async {
        print("CYCLE")
        
        if (self.locationAuthState == .authorized) {
            self.screen = .home
        }
        
        guard let fromStation = self.fromStation else  {
            print("CYCLE: no from station")
            return
        }
        
        do {
            let trains = try await self.api.trainsFrom(from: fromStation, timeConfig: TripTime(type: .now))
            self.trains = trains
            // print(trains)
        } catch {
            
        }
    }
    
}
