//
//  AppClipState.swift
//  Arrival BART Clip
//
//  Created by Ronan Furuta on 9/21/21.
//

import Foundation
import ArrivalCore
import ArrivalUI
import Combine
import CoreLocation
import SwiftUI
import Network

@MainActor
class AppClipState:  NSObject, ObservableObject, CLLocationManagerDelegate {
    //Publishers
    @Published var key: String? = nil
    
    @Published var screen: AppScreen = .loading
    @Published var fromStationChooser = false
    @Published var toStationChooser = false
    @Published var timeChooser = false
    // @Published var settingsModal = false
    
    @Published var locationAuthState = LocationAuthState.notAuthorized
    @Published var locationDataState  = LocationDataSate.notReady
    
    
    @Published var goingOffOfClosestStation = true
    
    @Published var fromStation: Station? = nil
    @Published var toStation: Station? = nil
    @Published var timeConfig: TripTime = TripTime(type: .now)
    
    @Published var directionFilter: Int = 1
    
    @Published var trips: [Trip] = []
    @Published var trains: [Train] = []
    @Published var northTrains: [Train] = []
    @Published var southTrains: [Train] = []
    @Published var lastCycle = Date()
    
    @Published var trainsLoading = true
    @Published var firstCycleOfFromStation = true
    
    //stations state
    @Published var stations: StationStorage? = nil
    @Published var closestStations: [Station] = []
    @Published var toStationSuggestions: [Station] = []
    @Published var fromStationSuggestions: [Station] = []
    
    @Published var tripDisplay: Trip? = nil
    @Published var diplayTripModal = false
    
    // @Published var alerts: [BARTAlert] = []
    // @Published var message: String? = nil
    
    @Published var cycling: Int = 0
    //Services
    let api = ArrivalAPI()
    let disk = DiskService()
    let stationService = StationService()
    let mapService = MapService()
    // let aiService = AIService()
    
    //Constants
    let defaults = UserDefaults.standard
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    let mode = RunMode.development
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    
    //Location state
    private var locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
    private var location: CLLocation? = nil
    var sessionID: UUID = UUID()
    private var handleTrainsToStationIntent: String? = nil
    
    
    //Watchers
    
    private var cycleTimerLength: TimeInterval = 30
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        
        Task() {
            await self.startUp()
        }
        
    }
    func startUp() async {
        print("starting up")
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
            await self.createAccount()
        }
        
    }
    func runOnboarding() {
        Task {
            await self.createAccount()
        }
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
        // print("LOCATION: update")
        if let location = locations.first {
            //print(location.coordinate, "location", location)
            if let currentLocation = self.location {
                guard  location.distance(from: currentLocation) > 10 else{
                    //    print("LOCATION: within 10m cancel refresh")
                    return
                }
            }
            
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            self.location = location
            self.mapService.location = location
            Task {
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
                Task {
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
        print("creating account")
        self.screen = .loading
        if (self.mode == .production) {
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
        } else {
            do {
                let loginResult = try await self.api.login(auth: "test")
                
                guard loginResult else {
                    //TODO: Catch this
                    return
                }
                self.defaults.set("test", forKey: "passphrase")
                self.key = "test"
                await self.startMain()
            } catch {
                
            }
        }
    }
    func onAppear() async {
        print("ON APPEAR", Date().timeIntervalSince(self.lastCycle))
        if Date().timeIntervalSince(self.lastCycle) >= 60*5 {
            
            await self.startMain()
            
        } else {
            self.sessionID = UUID()
            await self.cycle()
        }
    }
    func startMain() async {
        print("start main")
        self.requestLocation()
        self.screen = .loading
        guard self.key != nil else {
            self.runOnboarding()
            return
        }
        self.sessionID = UUID()
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
        print("show home screen")
        self.screen = .home
        Timer.scheduledTimer(withTimeInterval: self.cycleTimerLength, repeats: true) { timer in
            Task(priority: .high) {await self.cycle()}
        }
       
        
    }
    
    func getClosestStations() async -> [Station] {
        print("LOCATION STATION: refresh closest station")
        if let stations = self.stations {
            if let location = self.location {
                let stations =  await self.stationService.getClosestStations(stations: stations.stations, location: location)
                self.closestStations = stations
                await self.setFromStationSuggestions()
                if self.goingOffOfClosestStation {
                    
                    guard self.fromStation != stations[0] else {
                        return self.closestStations
                    }
                    
                    self.fromStation = stations[0]
                    self.trainsLoading = true
                    self.trains = []
                    self.northTrains = []
                    self.southTrains = []
                    print("LOCATION: going off closest station", stations[0].name, self.fromStation?.name as Any)
                    
                    // self.locationServicesState = .ready
                    
                    await self.cycle()
                   
                    
                }
                if let fromStation = self.fromStation {
                    if fromStation == stations[0] {
                        self.goingOffOfClosestStation = true
                    }
                }
                
                return stations
                
            } else  {
                self.closestStations = stations.stations
                
                await self.setFromStationSuggestions()
                
                return stations.stations
            }
            
        } else {
            
            return []
            
            
            
        }
        
    }
    func setFromStationSuggestions() async {
        guard self.stations?.stations.count ?? 0 > 1 else {
            return
        }
        var result: [Station] = []
        if (self.closestStations.count > 1) {
            result = closestStations
        } else {
            print("TO STATION SUGGESTIONS: going off of API")
            result = self.stations?.stations ?? []
        }
        
        for i in 0...4 {
            result[i].firstFive = true
        }
        for i in 4..<result.count {
            result[i].firstFive = false
        }
        self.fromStationSuggestions = result
    }
    
    func cycle() async {
        print("CYCLE")
        
        if (self.locationAuthState == .authorized) {
            self.screen = .home
        }
        self.cycling += 1
        
        guard let fromStation = self.fromStation else  {
            print("CYCLE: no from station")
            self.cycling += -1
            return
        }
       
        do {
            print("get trains from \(self.fromStation?.name ?? "none")")
            let (trains, north, south) = try await self.api.trainsFrom(from: fromStation, timeConfig: TripTime(type: .now))
            self.trains = trains
            self.northTrains = north
            self.southTrains = south
            print("got \(trains.count) trains from \(self.fromStation?.name ?? "none")")
            if (self.firstCycleOfFromStation) {
                print("first cycle directions \(north.count) \(south.count)")
                if (south.count == 0 && north.count == 0) {
                    self.directionFilter = 3
                } else if (south.count == 0 && north.count > 0) {
                    // aiService.predictDirectionFilter(fromStation)
                    self.directionFilter = 1
                }
                else if (south.count > 0 && north.count == 0) {
                    self.directionFilter = 2
                    
                    // aiService.predictDirectionFilter(fromStation)
                    
                    
                }
                
                self.firstCycleOfFromStation = false
            }
            self.trainsLoading = false
           
            // print(trains)
            self.lastCycle = Date()
        } catch {
            print("ERROR getting trains", error)
            //TODO: catch this
        }
        
        self.cycling += -1
    }
    func setFromStation(_ station: Station) {
        self.trains = []
        self.northTrains = []
        self.southTrains = []
        self.fromStation = station
        if (station.abbr != self.closestStations.first?.abbr) {
            print("not going off of closest station \(station.abbr) closest \(self.closestStations.first?.abbr ?? "none")")
            self.goingOffOfClosestStation = false
        } else {
            print("going off of closest station \(station.abbr)")
            self.goingOffOfClosestStation = true
        }
        self.trainsLoading = true
        self.firstCycleOfFromStation = true
        Task(priority: TaskPriority(rawValue: 2)) {
           
            await self.cycle()
        }
       
    }
   
   
 
}
