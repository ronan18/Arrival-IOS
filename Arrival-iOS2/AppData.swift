//
//  AppData.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/15/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import SwiftyJSON
import Alamofire
import CoreLocation
import CoreML
import JavaScriptCore
import FirebasePerformance
import FirebaseAnalytics
import FirebaseRemoteConfig
import FirebaseCrashlytics
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let baseURL = "https://api.arrival.city"
var jsContext: JSContext!
class AppData: NSObject, ObservableObject,CLLocationManagerDelegate {
    @Published var screen: String = "home"
    @Published var trains: Array = [Train]()
    @Published var northTrains: Array = [Train]()
    @Published var southTrains: Array = [Train]()
    @Published var passphrase: String = ""
    @Published var ready: Bool = false
    @Published var loaded: Bool = false
    @Published var noTrains: Bool = false
    @Published var auth: Bool = false
    @Published var locationAcess = true
    @Published var authLoading: Bool = false
    @Published var stations = [Station]()
    @Published var stationsByAbbr: [String: Station] = ["none": Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0)]
    @Published var network = true
    @Published var sortTrainsByTime = false
    @Published var goingOffClosestStation: Bool = true
    @Published var closestStations = [Station]()
    @Published var fromStationSuggestions = [Station]()
    @Published var toStationSuggestions = [Station]()
    @Published var loginError = ""
    @Published var trips: Array = [TripInfo]()
    @Published var routes: [String: Route]? = nil
    @Published var fromStation: Station = Station(id: "loading", name: "loading", lat: 0.0, long: 0.0, abbr: "load", version: 0)
    @Published var toStation: Station = Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0)
    @Published var onboardingMessages = JSON(["onboarding1Heading": ""])
    @Published var onboardingLoaded = false
    @Published var aboutText = ""
    @Published var realtimeTripNotice = ""
    @Published var privacyPolicy = ""
    @Published var termsOfService = ""
    @Published var remoteConfig = RemoteConfig.remoteConfig()
    @Published var cycleTimer: Double = 30
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLat = 0.0
    private var lastLong = 0.0
    private var allowCycle = true
    private var netJSON: [String: Any?] = [:]
    private var settingsSuscriber: Any?
    private var authSubscriber: Any?
    private var prioritizeLineSubscriber: Any?
    private var closestStationsSuscriber: Any?
    private var initialTrainsTrace: Trace?
    private var cycleTrace: Trace?
    private var initialTrainsTraceDone: Bool = false
   
    private let settings = RemoteConfigSettings()
    private var apiUrl = "https://api.arrival.city"
    
    override init() {
        super.init()
        print("init function")
        settings.minimumFetchInterval = 43200
        
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        self.apiUrl = self.remoteConfig["apiurl"].stringValue!
        self.cycleTimer = Double(self.remoteConfig["cycleTimer"].stringValue!)!
        let preferencesEntity = NSEntityDescription.entity(forEntityName: "Preferences", in: context)!
        let newTestPref = NSManagedObject(entity: preferencesEntity, insertInto: context)
        newTestPref.setValue(false, forKey: "prioritizeTrain")
        newTestPref.setValue(true, forKey: "sortTrainsByTime")
        do {
            try context.save()
        } catch {
            print("failed so save testing pref")
        }
        let expirationDuration: TimeInterval = 43200
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                   DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block config")
                        print(self.remoteConfig["apiurl"].stringValue, "remote config api value")
                        print(self.remoteConfig["onboarding1Heading"].stringValue, "remote config onboarding1Heading value")
                        self.apiUrl = self.remoteConfig["apiurl"].stringValue!
                        self.onboardingMessages["onboarding1Heading"] = JSON(self.remoteConfig["onboarding1Heading"].stringValue!)
                        self.onboardingMessages["onboarding2Heading"] = JSON(self.remoteConfig["onboarding2Heading"].stringValue!)
                        self.onboardingMessages["onboarding3Heading"] = JSON(self.remoteConfig["onboarding3Heading"].stringValue!)
                        self.onboardingMessages["onboarding1Tagline"] = JSON(self.remoteConfig["onboarding1Tagline"].stringValue!)
                        self.onboardingMessages["onboarding2Tagline"] = JSON(self.remoteConfig["onboarding2Tagline"].stringValue!)
                        self.onboardingMessages["onboarding3Tagline"] = JSON(self.remoteConfig["onboarding3Tagline"].stringValue!)
                        print(self.onboardingMessages.dictionaryObject, "config  onboarding messages")
                        self.onboardingLoaded = true
                    self.aboutText = self.remoteConfig["aboutText"].stringValue!
                     self.realtimeTripNotice = self.remoteConfig["realtimeTripsNotice"].stringValue!
                    self.privacyPolicy = self.remoteConfig["privacyPolicyUrl"].stringValue!
                          self.termsOfService = self.remoteConfig["termsOfServiceUrl"].stringValue!
                        print(self.onboardingLoaded, "config onboarding loaded")
                    }
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
        }
          
        
        // print("got onboarding config", onboardingMessages.dictionaryObject)
        self.initialTrainsTrace = Performance.startTrace(name: "initalTrainsDisplay")!
        testNetwork()
        start()
        getStations()
        
    }
    func testNetwork() {
        print("network testing")
        let headers: HTTPHeaders = [
                           "Authorization": self.passphrase,
                           "Accept": "application/json"
                       ]
                       Alamofire.request(apiUrl, headers: headers).response { response in
                        print("network Test", response.error)
                        self.network = response.error == nil
        }
        
    }
    func logOut() {
        self.passphrase = ""
        self.auth = false
        self.loaded = false
        self.goingOffClosestStation = true
        self.screen = "home"
        self.toStation = Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Failed saving")
        }
        
        
        
    }

    func convertColor(color: String) -> Color {
        
        switch (color.lowercased()) {
        case "red" :
            return Color.red
        case "yellow" :
            return Color.yellow
        case "green" :
            return Color.green
        case "orange" :
            return Color.orange
        case "purple" :
            return Color.purple
        case "blue" :
            return Color.blue
        case "white" :
            return Color(UIColor.systemIndigo)
        case "none" :
            return Color.white
        default :
            return Color.black
            
        }
    }
    func tripToDouble(day: Int, hour: Int, fromStation: String) -> [Double] {
        let dayDouble = Double(day)
        let hourDouble = Double(hour)
        let fromStationDouble = stationToDouble(station:fromStation)
        return [dayDouble,hourDouble, fromStationDouble]
    }
    func stationToDouble(station: String) -> Double {
        print(station, "station to double")
        return Double(self.stations.firstIndex(where: { $0.abbr == station })!)
    }
    func stationFromInt(label: Int) -> String {
        
        return self.stations[label].abbr
    }
    func computeToSuggestions(pass: String = "") {
        if (self.fromStation.id != "loading") {
            var knnPass = pass
            if (pass.isEmpty) {
                knnPass = self.passphrase
            }
            print("knn pass", knnPass, pass)
            let day = Calendar.current.component(.weekday, from: Date()) as Int
            let hour = Calendar.current.component(.hour, from: Date()) as Int
            print(hour, day, "time, ai")
            
            
            let managedContext =  appDelegate.persistentContainer.viewContext
            let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
            var trainingData: [[Double]] = []
            var labels: [Int] = []
            do {
                var priorities: [String: Int] = [:]
                
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    let toStation = data.value(forKey: "toStation") as! String
                    let fromStation = data.value(forKey: "fromStation") as! String
                    var user = data.value(forKey: "user")
                    let hour = data.value(forKey: "hour") as! Int
                    let day = data.value(forKey: "day") as! Int
                    if (user  == nil) {
                        data.setValue(knnPass, forKey: "user")
                        user = knnPass
                    }
                    //let userString = user as! String
                    print("knn user", user, "knn pass", knnPass, user as! String == knnPass, user == nil)
                    
                    if (user as! String == knnPass) {
                        print("knn data", user, hour, day, toStation, fromStation)
                        
                        if (toStation != "none" && fromStation != "load") {
                            if (JSON(priorities)[toStation].intValue > 0) {
                                priorities[toStation] = priorities[toStation]! + 1
                            } else {
                                priorities[toStation] = 1
                            }
                            
                            trainingData.append(tripToDouble(day: day, hour: hour, fromStation: fromStation))
                            labels.append(Int(stationToDouble(station: toStation)))
                        }
                        print(toStation, "to Stations")
                    }
                }
                print(trainingData, labels, "knn data")
                var predictionType: [String]
                if (!trainingData.isEmpty) {
                    
                    var nNeighbors = priorities.count - 1
                    if nNeighbors < 1 {
                        nNeighbors = 1
                    }
                    nNeighbors = 1
                    
                    print(nNeighbors, "knn neighbors")
                    do {
                        let knn = try KNearestNeighborsClassifier(data: trainingData, labels: labels, nNeighbors: nNeighbors)
                        if (self.fromStation.abbr != "load") {
                            print("knn predicting", self.fromStation.abbr)
                            let predictionLabels = try knn.predict([tripToDouble(day: day, hour: hour, fromStation: self.fromStation.abbr)])
                            print(predictionLabels, "knn prediction labels")
                            predictionType = predictionLabels.map({ self.stationFromInt(label: $0) })
                            print(predictionType, "knn prediction type")
                            priorities[predictionType[0]] = (JSON(priorities)[predictionType[0]].intValue + 100) * 10
                        }
                    } catch {
                        print("crash", error)
                        Crashlytics.crashlytics().record(error: error)
                        
                    }
                    
                }
                do {
                    try context.save()
                    print("updated trips")
                } catch {
                    print("failed updating trips")
                }
                print(priorities, "to Stations")
                self.toStationSuggestions = self.stations.sorted {
                    var s1 = 0
                    var s2 = 0
                    if (JSON(priorities)[$0.abbr].intValue > 0) {
                        s1 = JSON(priorities)[$0.abbr].intValue
                    }
                    if (JSON(priorities)[$1.abbr].intValue > 0) {
                        s2 = JSON(priorities)[$1.abbr].intValue
                    }
                    // print(s1, s2, $0.abbr, $1.abbr, "to Stations")
                    return s1 > s2
                }
                self.toStationSuggestions = self.toStationSuggestions.filter{
                    return self.fromStation.abbr != $0.abbr
                }
                
                self.toStationSuggestions.insert(Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0), at: 0)
            } catch {
                print("failed to get trips")
                
            }
        } else {
            self.toStationSuggestions = self.stations
        }
        /*
         let brainJSSource: String = Bundle.main.path(forResource: "brain", ofType: "js") as! String
         if let jsSourcePath = Bundle.main.path(forResource: "toStations", ofType: "js") {
         do {
         // Load its contents to a String variable.
         let jsSourceContents = try String(contentsOfFile: jsSourcePath)
         let brainContents = try String(contentsOfFile: brainJSSource)
         // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
         jsContext.evaluateScript(brainContents)
         jsContext.evaluateScript(jsSourceContents)
         
         
         if let functionCompute = jsContext.objectForKeyedSubscript("getToStations") {
         if let results = functionCompute.call(withArguments: [self.netJSON, day, hour, self.fromStation.abbr]) {
         print(results, "brain ai")
         }
         }
         }
         catch {
         print(error.localizedDescription, "brain ai error")
         }
         }
         */
        
        
        
    }
    func setFromStation(station: Station) {
        print("setting from Station", station)
        self.loaded = false
        self.noTrains = false
        self.fromStation = station
        computeToSuggestions()
        if (!self.closestStations.isEmpty) {
            if (station.abbr == self.closestStations[0].abbr) {
                self.goingOffClosestStation = true
            } else {
                self.goingOffClosestStation = false
            }
        } else {
            self.goingOffClosestStation = false
        }
        
        self.cylce()
        Analytics.logEvent("set_fromStation", parameters: [
            "station": station.abbr as NSObject
        ])
    }
    func setToStation(station: Station) {
        print("setting to Station")
        self.loaded = false
         self.noTrains = false
        self.toStation = station
        self.cylce()
        let day = Calendar.current.component(.weekday, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: context)!
        let trip = NSManagedObject(entity: tripEntity, insertInto: context)
        trip.setValue(self.fromStation.abbr, forKeyPath: "fromStation")
        trip.setValue(self.toStation.abbr, forKeyPath: "toStation")
        trip.setValue(day, forKeyPath: "day")
        trip.setValue(hour, forKeyPath: "hour")
        trip.setValue(self.passphrase, forKeyPath: "user")
        Analytics.logEvent("set_toStation", parameters: [
            "station": station.abbr as NSObject,
            "fromStation": self.fromStation.abbr as NSObject
        ])
        do {
            try context.save()
            computeToSuggestions()
        } catch let error as NSError {
            print(error)
        }
        
        
    }
    @objc func cylce() {
        
        getClosestStations()
        if (self.fromStation.name != "loading" && self.auth && self.ready && !self.passphrase.isEmpty && allowCycle) {
            self.cycleTrace = Performance.startTrace(name: "cycle")
            print("cycling", self.passphrase)
            if (self.toStation.id == "none" ) {
                print("fetching trains from", self.fromStation.abbr)
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                Alamofire.request(apiUrl + "/api/v2/trains/" + self.fromStation.abbr, headers: headers).responseJSON { response in
                    // print(JSON(response.value))
                    let estimates = JSON(JSON(response.value)["estimates"]["etd"].arrayValue)
                    //   print(estimates.count)
                    
                    //TODO Fix error handeling
                    if (estimates.count > 0) {
                        var results: Array = [Train]()
                        var northResults: Array = [Train]()
                        var southResults: Array = [Train]()
                        for i in 0...estimates.count - 1 {
                            for x in 0...estimates[i]["estimate"].arrayValue.count - 1 {
                                let thisTrain = estimates[i]["estimate"][x]
                                let color = thisTrain["color"].stringValue
                                if (thisTrain["direction"].stringValue == "North") {
                                    northResults.append(Train(id: UUID(), direction: estimates[i]["destination"].stringValue, time: thisTrain["minutes"].stringValue, unit: "min", color: color, cars: thisTrain["length"].intValue, hex: thisTrain["hexcode"].stringValue, eta: ""))
                                } else {
                                    southResults.append(Train(id: UUID(), direction: estimates[i]["destination"].stringValue, time: thisTrain["minutes"].stringValue, unit: "min", color: color, cars: thisTrain["length"].intValue, hex: thisTrain["hexcode"].stringValue, eta: ""))
                                }
                                results.append(Train(id: UUID(), direction: estimates[i]["destination"].stringValue, time: thisTrain["minutes"].stringValue, unit: "min", color: color, cars: thisTrain["length"].intValue, hex: thisTrain["hexcode"].stringValue, eta: ""))
                            }
                        }
                        results.sort {
                            var time1: Int
                            var time2: Int
                            // print($0.time, $1.time)
                            if ($0.time == "Leaving") {
                                time1 = 0
                            } else {
                                time1 = Int($0.time)  as! Int
                            }
                            if ($1.time == "Leaving") {
                                time2 = 0
                            } else {
                                time2 = Int($1.time) as! Int
                            }
                            
                            
                            //print(time1, time2)
                            return time1 < time2
                        }
                        northResults.sort {
                            var time1: Int
                            var time2: Int
                            // print($0.time, $1.time)
                            if ($0.time == "Leaving") {
                                time1 = 0
                            } else {
                                time1 = Int($0.time)  as! Int
                            }
                            if ($1.time == "Leaving") {
                                time2 = 0
                            } else {
                                time2 = Int($1.time) as! Int
                            }
                            
                            
                            //print(time1, time2)
                            return time1 < time2
                        }
                        southResults.sort {
                            var time1: Int
                            var time2: Int
                            // print($0.time, $1.time)
                            if ($0.time == "Leaving") {
                                time1 = 0
                            } else {
                                time1 = Int($0.time)  as! Int
                            }
                            if ($1.time == "Leaving") {
                                time2 = 0
                            } else {
                                time2 = Int($1.time) as! Int
                            }
                            
                            
                            //print(time1, time2)
                            return time1 < time2
                        }
                        self.noTrains = false
                        self.northTrains = northResults
                        self.southTrains = southResults
                        self.trains = results
                        self.loaded = true
                        if (!self.initialTrainsTraceDone) {
                            self.initialTrainsTrace!.stop()
                            self.initialTrainsTraceDone = true
                        }
                        self.cycleTrace!.stop()
                        
                    } else {
                        self.loaded = true
                        self.noTrains = true
                        self.cycleTrace!.stop()
                    }
                }
            } else {
                print("fetching trips from", self.fromStation.abbr, "to", self.toStation.abbr )
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                print(apiUrl + "/api/v3/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr)
                Alamofire.request(apiUrl + "/api/v3/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr, headers: headers).responseJSON { response in
                    
                    
                    let estimates = JSON(JSON(response.value)["trips"].arrayValue)
                    if (estimates.count > 0) {
                        
                        var routes: [String: Route] = [:]
                        for (id, route) in JSON(response.value)["routes"].dictionaryObject! {
                            //  print(id, route)
                            let routeJSON = JSON(route)
                            let stations = routeJSON["config"]["station"].arrayValue.map { $0.stringValue}
                            //  print(stations, "route stations")
                            routes[id] = Route(name: routeJSON["name"].stringValue, abbr: routeJSON["abbr"].stringValue, routeID: routeJSON["routeID"].stringValue, origin: routeJSON["origin"].stringValue, destination: routeJSON["destination"].stringValue, direction: routeJSON["direction"].stringValue, color: routeJSON["color"].stringValue, stations: stations)
                        }
                        
                        
                        self.routes = routes
                        print(self.routes, "routes after intial")
                        //   print(estimates.count)
                        var results: Array = [Train]()
                        var trips: Array = [TripInfo]()
                        
                        for x in 0...estimates.count - 1 {
                            let thisTrain = estimates[x]
                            let etd = thisTrain["@origTimeMin"].stringValue
                            let eta = thisTrain["@destTimeMin"].stringValue
                            let direction = thisTrain["leg"][0]["@trainHeadStation"].stringValue
                            var legs: Array = [Leg]()
                            for i in 0...thisTrain["leg"].count - 1 {
                                let leg = thisTrain["leg"][i]
                                let origin = self.stationsByAbbr[leg["@origin"].stringValue]!.name
                                let destination = self.stationsByAbbr[leg["@destination"].stringValue]!.name
                                let line = leg["@line"].stringValue
                                
                                let routeNum = leg["route"].stringValue
                                
                                if (self.routes![routeNum] != nil) {
                                    let routeJSON = self.routes![routeNum]!
                                    let fromStationIndex = routeJSON.stations.firstIndex(of: leg["@origin"].stringValue)
                                    let toStationIndex = routeJSON.stations.firstIndex(of: leg["@destination"].stringValue)
                                    print(fromStationIndex, toStationIndex, origin, destination)
                                    
                                    
                                    let stopCount = abs(toStationIndex! - fromStationIndex!)
                                    
                                    
                                    print(stopCount, "route stop count")
                                    
                                    var type: String
                                    if (i == thisTrain["leg"].count - 1) {
                                        type = "destination"
                                    } else if (i == 0) {
                                         type = "board"
                                    }   else {
                                        type = "transfer"
                                    }
                                    var transferWait: String?
                                    if (i != 0) {
                                        let lastTrainString = thisTrain["leg"][i - 1]["@destTimeMin"].stringValue
                                        let originTimeString = leg["@origTimeMin"].stringValue
                                        let lastTrainTime = moment(lastTrainString, "HH:mm")
                                        let originTime = moment(originTimeString, "HH:mm")
                                        let difference = originTime.diff(lastTrainTime, "minutes")
                                         transferWait = difference.stringValue + " min"
                                        print(lastTrainTime.format(), originTime.format(), difference, transferWait, "transfer wait")
                                    }
                                    let enrouteTime = moment(leg["@destTimeMin"].stringValue, "HH:mm").diff(moment(leg["@origTimeMin"].stringValue, "HH:mm"), "minutes")
                                   let enrouteTimeString = enrouteTime.stringValue + "min"
                                    
                                    // print(routeJSON.dictionaryObject, "route for route", routeNum, "color", routeJSON["color"].stringValue)
                                    
                                    legs.append(Leg(order: leg["@order"].intValue, origin: origin, destination: destination, originTime: leg["@origTimeMin"].stringValue, destinationTime: leg["@destTimeMin"].stringValue, line: leg["@line"].stringValue, route: leg["route"].intValue, trainDestination: leg["@trainHeadStation"].stringValue,  color:routeJSON.color, stops: stopCount, type: type, enrouteTime: enrouteTimeString, transferWait: transferWait))
                                } else {
                                    print("route for route", routeNum, leg, "doesn't exist")
                                }
                                
                                
                            }
                            //let color = thisTrain["color"].stringValue
                            let color = "none"
                            print(eta)
                            let originTime = moment(thisTrain["@origTimeMin"].stringValue, "HH:mm")
                            let now = moment()
                            let difference = originTime.diff(now, "minutes").intValue
                            results.append(Train(id: UUID(), direction: direction, time: etd, unit: "", color: "none", cars: 0, hex: "0", eta: eta))
                            trips.append(TripInfo(origin: self.fromStation.abbr, destination: direction, legs: legs, originTime: thisTrain["@origTimeMin"].stringValue, destinatonTime: thisTrain["@destTimeMin"].stringValue, tripTIme: thisTrain["@tripTime"].doubleValue, leavesIn: difference))
                        }
                        
                        results.sort {
                            $0.time < $1.time
                        }
                        
                        self.noTrains = false
                        self.trains = results
                        self.trips = trips
                        self.loaded = true
                        self.cycleTrace!.stop()
                    } else {
                        self.loaded = true
                        self.noTrains = true
                        self.cycleTrace!.stop()
                    }
                }
            }
            
        } else {
            print("cycling failed due to invalid data")
            let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(cylce), userInfo: nil, repeats: false)
            
        }
        
    }
    private func start() {
        
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        closestStationsSuscriber = $closestStations.sink {value in
            print (value, "closest Stations suscriber")
            if (value.isEmpty) {
                self.fromStationSuggestions = self.stations
            } else {
                self.fromStationSuggestions = value
            }
        }
        authSubscriber = $passphrase.sink {value in
            print(value, "auth subscriber")
            if (self.auth) {
                print("passphrase changed and auth settings from auth", value)
                
                self.computeToSuggestions(pass: value)
                let managedContext =  appDelegate.persistentContainer.viewContext
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Preferences")
                do {
                    
                    let result = try managedContext.fetch(fetchRequest)
                    if (!result.isEmpty) {
                        print("fetching settings from auth")
                        for data in result as! [NSManagedObject] {
                           
                            var sortTrainsByTimeSetting: Bool
                            let user: String
                            do {
                                 let testUser = try data.value(forKey: "user")
                                if testUser == nil {
                                    user = ""
                                } else {
                                    user = testUser as! String
                                }
                            } catch {
                                user  =  ""
                            }
                            do {
                                  
                                 let tempSetting  =  try data.value(forKey: "sortTrainsByTime")
                                if (tempSetting == nil) {
                                    sortTrainsByTimeSetting = false
                                } else {
                                    sortTrainsByTimeSetting = tempSetting as! Bool
                                }
                            } catch {
                                sortTrainsByTimeSetting = false
                                
                            }
                           
                            if (sortTrainsByTimeSetting == nil) {
                                sortTrainsByTimeSetting = false
                            }
                            print(data.value(forKey: "prioritizeTrain"), "setting")
                         //   let prioritizeTrainSettingValue = data.value(forKey: "prioritizeTrain")
                            
                            print(user, value, "user settings from auth")
                         //   print( prioritizeTrainSettingValue, "sort t b t settings from auth")
                            if (user == value) {
                                self.sortTrainsByTime = sortTrainsByTimeSetting
                             
                                
                                
                                print("set stbt settings from auth to", sortTrainsByTimeSetting)
                            }
                            
                        }
                    } else {
                        self.sortTrainsByTime = false
                    }
                    
                    
                } catch {
                    print("failed to get settings")
                    
                }
            }
        }
       
        settingsSuscriber = $sortTrainsByTime.sink {value in
            print(value, "settings change")
            if (self.auth){
                Analytics.setUserProperty(String(value), forName: "sortTrainsByTime")
                let managedContext =  appDelegate.persistentContainer.viewContext
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Preferences")
                do {
                    
                    let result = try managedContext.fetch(fetchRequest)
                    if (!result.isEmpty) {
                        print("fetching old settings")
                        for data in result as! [NSManagedObject] {
                            var user = ""
                            do {
                                   var temp =  try data.value(forKey: "user")
                                if (temp != nil) {
                                    user = temp as! String
                                }
                            } catch {
                                user = ""
                            }
                          
                            
                            var sortTrainsByTimeSetting = false
                            do {
                              var temp = try data.value(forKey: "sortTrainsByTime")
                                if  (temp != nil) {
                                    sortTrainsByTimeSetting = temp as! Bool
                                }
                                
                            } catch {
                                sortTrainsByTimeSetting = false
                            }
                            print(user, "user setting")
                            print(sortTrainsByTimeSetting, "sort t b t setting")
                            if (user == self.passphrase) {
                                data.setValue(value, forKey: "sortTrainsByTime")
                                do {
                                    try context.save()
                                    print("saved updated settings")
                                } catch {
                                    print("Failed saving")
                                }
                            }
                            
                        }
                    } else {
                        print("creating new settings")
                        let entity = NSEntityDescription.entity(forEntityName: "Preferences", in: context)
                        let newPreference = NSManagedObject(entity: entity!, insertInto: context)
                        newPreference.setValue(self.passphrase, forKey: "user")
                        newPreference.setValue(value, forKey: "sortTrainsByTime")
                        do {
                            try context.save()
                            print("saved new settings")
                        } catch {
                            print("Failed saving")
                        }
                    }
                    
                    
                } catch {
                    print("failed to get settings")
                    
                }
            }
        }
        
    }
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            getClosestStations()
        }
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationAcess = true
                Analytics.setUserProperty("true", forName: "locationAccess")
            }
        case .restricted, .denied:
            self.locationAcess = false
            Analytics.setUserProperty("false", forName: "locationAccess")
        }
    }
    func getClosestStations() {
        if (!stations.isEmpty && lat != 0.0 && long != 0.0) {
            let locChange = lat != lastLat || long != lastLong
            if locChange {
                lastLong = long
                lastLat = lat
                print("getting nearest station")
                let myCord: CLLocation = CLLocation(latitude: lat, longitude: long)
                let testingStations = self.stations.sorted {
                    let station1Loc: CLLocation = CLLocation(latitude: $0.lat, longitude: $0.long)
                    let station2Loc: CLLocation = CLLocation(latitude: $1.lat, longitude: $1.long)
                    let distance1Miles = myCord.distance(from: station1Loc)
                    let distance2Miles = myCord.distance(from: station2Loc)
                    return distance1Miles < distance2Miles
                }
                if (self.closestStations.isEmpty || testingStations[0].name != self.closestStations[0].name) {
                    
                    
                    self.closestStations = testingStations
                    print(self.closestStations)
                    if (self.goingOffClosestStation) {
                        self.fromStation = self.closestStations[0]
                        computeToSuggestions()
                        self.cylce()
                    }
                } else {
                    print("Stations calculated but no change in order")
                }
            } else {
                print("no loc change")
            }
            
        } else {
            print("getting nearest station FAILED due to lack of info")
        }
    }
    func getStationsFromApi() {
        print("getting stations from api")
        Alamofire.request(apiUrl + "/api/v3/stations")
            .responseJSON{
                response in print(response)
                if  response.value != nil {
                    let stationJSON = JSON(response.value)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationModel")
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    for i in 0..<stationJSON["stations"].arrayValue.count {
                        let json = stationJSON["stations"][i]
                        let id = json["_id"].stringValue
                        let name = json["name"].stringValue
                        let abbr = json["abbr"].stringValue
                        let lat = json["gtfs_latitude"].doubleValue
                        let long = json["gtfs_longitude"].doubleValue
                        let entity = NSEntityDescription.entity(forEntityName: "StationModel", in: context)
                        let newStation = NSManagedObject(entity: entity!, insertInto: context)
                        newStation.setValue(name, forKey: "name")
                        newStation.setValue(id, forKey: "id")
                        newStation.setValue(abbr, forKey: "abbr")
                        newStation.setValue(lat, forKey: "lat")
                        newStation.setValue(long, forKey: "long")
                        newStation.setValue(stationJSON["version"].intValue, forKey: "version")
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                        self.stations.append(Station(id:id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue))
                        self.stationsByAbbr[abbr] = Station(id:id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue)
                    }
                    //   print(self.stations)
                    self.fromStationSuggestions = self.stations
                    print("got stations from server")
                    self.getClosestStations()
                    
                } else {
                    print("error retreving stations")
                    self.network = false
                }
        }
    }
    func getStations() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StationModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var stations: [Station] = []
            var version: Int = 0
            for data in result as! [NSObject] {
                let name = data.value(forKey: "name") as! String
                let abbr = data.value(forKey: "abbr") as! String
                let id = data.value(forKey: "id") as! String
                let lat = data.value(forKey: "lat") as! Double
                let long = data.value(forKey: "long") as! Double
                stations.append(Station(id: id,name: name,lat: lat,long: long,abbr: abbr, version: data.value(forKey: "version") as! Int))
                version = data.value(forKey: "version") as! Int
                self.stationsByAbbr[abbr] = Station(id: id,name: name,lat: lat,long: long,abbr: abbr, version: data.value(forKey: "version") as! Int)
            }
            print(stations, version)
            if (stations.isEmpty) {
                print("no coredata stations")
                getStationsFromApi()
            } else {
                self.stations = stations
                self.fromStationSuggestions = self.stations
                print("got stations from core data")
                getClosestStations()
            }
        }
        catch {
            print("failed to get stations from core data")
            getStationsFromApi()
        }
        
    }
    func load() {
        print ("load func ran")
    }
    func createNewAccount(passphrase: String) {
        self.authLoading = true
        print("creating account", passphrase)
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(apiUrl+"/api/v2/createaccount", method: .post, parameters: ["passphrase": passphrase]).responseJSON {
            response in
            if (response.value) != nil {
                let jsonResponse = JSON(response.value)
                if (jsonResponse["success"].boolValue) {
                    self.loginFromWeb(passphrase: passphrase)
                } else {
                    print("error creating account")
                }
            } else {
                print("error creating account")
                
            }
            
        }
    }
    func loginFromWeb(passphrase: String) {
        self.authLoading = true
        self.loginError = ""
        print("logging in from web", passphrase)
        let headers: HTTPHeaders = [
            "Authorization": passphrase,
            "Accept": "application/json"
        ]
        Alamofire.request(apiUrl + "/api/v2/login", headers: headers).responseJSON {
            response in //print(response.value)
            if  response.value != nil {
                let jsonResponse = JSON(response.value)
                if jsonResponse["user"].stringValue == "true" {
                    self.auth = true
                    self.ready = true
                    self.passphrase = passphrase
                    self.authLoading = false
                    print("user authorized")
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    let newUser = NSManagedObject(entity: entity!, insertInto: context)
                    newUser.setValue(passphrase, forKey: "pass")
                    Analytics.setUserID(passphrase)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                } else {
                    print("user not authorized")
                    self.auth = false
                    self.passphrase = ""
                    self.ready = true
                    self.authLoading = false
                    self.loginError = "Passphrase Incorrect"
                    //TODO handle showing error
                }
            } else {
                print("error logging in")
                // self.network = false
                // self.ready = true
            }
        }
    }
    func login() {
        print("logging in")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            if (result.isEmpty) {
                self.ready = true
                self.auth = false
                
            } else {
                
                let nsResult = result as! [NSObject]
                let passphraseToTest = nsResult[0].value(forKey: "pass") as! String
                print(passphraseToTest, "passphrase to  test login with")
                let headers: HTTPHeaders = [
                    "Authorization": passphraseToTest,
                    "Accept": "application/json"
                ]
                Alamofire.request(apiUrl+"/api/v2/login", headers: headers).responseJSON {
                    response in //print(response.value)
                    if  response.value != nil {
                        let jsonResponse = JSON(response.value)
                        if jsonResponse["user"].stringValue == "true" {
                            
                            self.auth = true
                            self.ready = true
                            print("user authorized")
                            Analytics.setUserID(passphraseToTest)
                            // print(jsonResponse["net"].dictionaryObject, "brain ai json raw")
                            if (!jsonResponse["net"].isEmpty) {
                                self.netJSON = jsonResponse["net"].dictionaryObject as! [String: Any?]
                                //print(self.netJSON, "brain ai json")
                            }
                            self.passphrase = passphraseToTest
                        } else {
                            print("user not authorized")
                            self.auth = false
                            self.passphrase = ""
                            self.ready = true
                            
                            //TODO remove core data storage of the invalid passphrase
                        }
                    } else {
                        print("error logging in")
                        // self.network = false
                        // self.ready = true
                    }
                }
                
            }
            
            
        }
        catch {}
    }
    
    
}
