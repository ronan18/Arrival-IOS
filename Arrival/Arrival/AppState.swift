//
//  AppState.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/24/21.
//

import Foundation
import ArrivalCore
import ArrivalUI
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
    @Published var fromStationChooser = false
    @Published var toStationChooser = false
    @Published var timeChooser = false
    
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
    
    
    @Published var trainsLoading = true
    @Published var firstCycleOfFromStation = true
    
    //stations state
    @Published var stations: StationStorage? = nil
    @Published var closestStations: [Station] = []
    @Published var toStationSuggestions: [Station] = []
    @Published var fromStationSuggestions: [Station] = []
    
    @Published var tripDisplay: Trip? = nil
    @Published var diplayTripModal = false
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
    
    //Location state
    private var locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLocation: CLLocation? = nil
    private var location: CLLocation? = nil
    
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
       
        if let id = self.handleTrainsToStationIntent {
            //self.trainsToStationIntent(id)
        }
        await self.cycle()
        print("show home screen")
        self.screen = .home
        Timer.scheduledTimer(withTimeInterval: self.cycleTimerLength, repeats: true) { timer in
            Task(priority: .high) {await self.cycle()}
        }
        Task(priority: .background) {
            async let test = trainAIAndGetSuggestions()
        }
       
    }
    func trainAIAndGetSuggestions() async {
      await aiService.train()
        await self.getToStationSuggestions()
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
                    print("LOCATION: going off closest station", stations[0].name, self.fromStation?.name as Any)
                    
                    // self.locationServicesState = .ready
                    
                    await self.cycle()
                    await self.getToStationSuggestions()
                    
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
    func getToStationSuggestions() async {
        print("geting to station suggestions")
        guard self.stations?.stations.count ?? 0 > 1 else {
            return
        }
        guard let stations = stations , let fromStation = self.fromStation else {
            return
        }
        
        var predictions = self.stationService.getToStationSuggestions(stations: stations, currentStation: fromStation)
        // print(predictions, "to Station predictions results")
        var result: [Station] = []
        if predictions.count > 0 {
            predictions = predictions.filter({a in
                return self.fromStation != a
            })
            struct stationScore {
                let station: Station
                let score: Double?
            }
            var scores: [stationScore] = []
            stations.stations.forEach({station in
                // print("scoring \(station.name)")
                guard let lat = station.lat , let long = station.long else {
                    //   print("no lat long station scores")
                    
                    scores.append(stationScore(station: station, score: nil))
                    return
                }
                
                guard let predictionStation = predictions.first else {
                    scores.append(stationScore(station: station, score: nil))
                    //print("no prediction station scores")
                    return
                }
                let targetStationLoc: CLLocation = CLLocation(latitude: lat, longitude: long)
                let predictionStationLoc: CLLocation = CLLocation(latitude: predictionStation.lat!, longitude: predictionStation.long!)
                let distance1Miles = predictionStationLoc.distance(from: targetStationLoc)
                
                
                scores.append(stationScore(station: station, score: distance1Miles))
                // scores[station] = highestScore
                
                
            })
        
            scores.sort {a,b in
                //   print("sorting \(a.station.name) and \(b.station.name) score")
                guard let aScore = a.score else {
                    //        print("no a score, \(a.station.name)")
                    return false
                }
                guard let bScore = b.score else {
                    //   print("no b score, \(b.station.name)")
                    return true
                }
                // print("\(aScore) \(bScore) score")
                return aScore < bScore
            }
            //  print("sorted scores")
            result = scores.map { item in
                return item.station
            }
            /*scores.sort {a,b in
             return a.score ?? 100*100 < b.score ?? 100*100
             })*/
            
        } else {
            if (self.closestStations.count > 1) {
                print("TO STATION SUGGESTIONS: going off of distance")
                result = closestStations.reversed()
            } else {
                print("TO STATION SUGGESTIONS: going off of API")
                result = self.stations?.stations ?? []
            }
        }
        result = result.filter({a in
            return self.fromStation != a && !predictions.contains(where: {station in
                station.abbr == a.abbr
            })
        })
        result.insert(contentsOf: predictions, at: 0)
        //print(result)
        for i in 0...4 {
            result[i].firstFive = true
        }
        for i in 4..<result.count {
            result[i].firstFive = false
        }
        self.toStationSuggestions = result
        
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
        
        guard let fromStation = self.fromStation else  {
            print("CYCLE: no from station")
            return
        }
        if let toStation = self.toStation {
            
            print("get trips from \(fromStation.name) to \(toStation.name) at \(self.timeConfig)")
            do {
                let trips = try await self.api.trips(from: fromStation, to: toStation, timeConfig: self.timeConfig)
                print("Got \(trips.count) trips from \(fromStation.name) to \(toStation.name) at \(self.timeConfig)")
                var result: [Trip] =  []
                trips.forEach { trip in
                    result.append(self.stationService.fillOutStations(forTrip: trip, stations: self.stations!))
                }
                self.trips = result
                self.trainsLoading = false
            } catch {
                //TODO: Handel errors from here
            }
        } else {
            print("No to station")
            do {
                print("get trains from \(self.fromStation?.name ?? "none")")
                let (trains, north, south) = try await self.api.trainsFrom(from: fromStation, timeConfig: TripTime(type: .now))
                self.trains = trains
                self.northTrains = north
                self.southTrains = south
                print("got \(trains.count) trains from \(self.fromStation?.name ?? "none")")
                if (self.firstCycleOfFromStation) {
                    // print("first cycle \(north) \(south)")
                    if (south.count == 0 && north.count == 0) {
                        self.directionFilter = 3
                    } else if (south.count == 0 && north.count > 0) {
                        self.directionFilter = 1
                    }
                    else if (south.count > 0 && north.count == 0) {
                        self.directionFilter = 2
                    }
                    
                    self.firstCycleOfFromStation = false
                }
                self.trainsLoading = false
                // print(trains)
            } catch {
                print("ERROR getting trains", error)
                //TODO: catch this
            }
        }
        
    }
    func setFromStation(_ station: Station) {
        self.fromStation = station
        if (station != self.closestStations.first) {
            self.goingOffOfClosestStation = false
        } else {
            self.goingOffOfClosestStation = true
        }
        self.trainsLoading = true
        self.firstCycleOfFromStation = true
        Task(priority: TaskPriority(rawValue: 2)) {
            await self.getToStationSuggestions()
            await self.cycle()
        }
        if let toStation =  self.toStation {
            aiService.logTripEvent(TripEvent(fromStation: station, toStation: toStation, date: Date()))
            Task(priority: .background) {
                await aiService.train()
            }
        }
    }
    func setToStation(_ station: Station?) {
        if (self.toStation != station) {
            self.trainsLoading = true
        }
        if (station == nil) {
            self.timeConfig = TripTime(type: .now)
        }
        self.toStation = station
        
        
        Task {
            await self.cycle()
        }
        if let station = station {
            guard let fromStation = fromStation else {
                return
            }
            aiService.logTripEvent(TripEvent(fromStation: fromStation, toStation: station, date: Date()))
        }
        Task(priority: .background) {
            await aiService.train()
        }
    }
    func setTripTime(_ time: TripTime) {
        self.timeConfig = time
        self.trainsLoading = true
        Task {
            await self.cycle()
        }
    }
    func trainsToStationIntent(departureStationID: String, destinationStationID: String) {
        /*  guard let stations = self.stations else {
         //  self.handleTrainsToStationIntent = (departureStationID, destinationStationID)
         return
         }
         self.handleTrainsToStationIntent = nil
         // let stationReq = self.stationService.getStationFromAbbr(id, stations: stations)
         guard let station = stationReq else {
         return
         }
         print(station)
         self.toStation = station
         */
    }
    
}
