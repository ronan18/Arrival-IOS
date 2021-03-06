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
import Disk
let dateFormate = "hh:mm A"
let dateFormateDate = "hh:mm A MM/DD/YYYY"
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
var jsContext: JSContext!
let defaults = UserDefaults.standard
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
    @Published var networkTestStatus = ""
    @Published var stationsByAbbr: [String: Station] = ["none": Station(id: "none", name: "none", lat: 0.0, long: 0.0, abbr: "none", version: 0)]
    @Published var network = true
    @Published var sortTrainsByTime = defaults.bool(forKey: "sortTrainsByTime")
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
    @Published var leaveTrainRealtimeNotice = ""
    @Published var privacyPolicy = ""
    @Published var termsOfService = ""
    @Published var remoteConfig = RemoteConfig.remoteConfig()
    @Published var cycleTimer: Double = 30
    @Published var reviewCard = false
    @Published var debug = false
    @Published var showTripDetailFeature = !defaults.bool(forKey: "shownDetailOnBoard")
    @Published var dynamicLinkTripId: String? = nil
    @Published var dynamicLinkTripData: TripInfo = TripInfo(origin: "", destination: "", legs: [Leg](), originTime: "", originDate: "", destinatonTime: "", destinatonDate: "", tripTIme: 0.0, leavesIn: 0, tripId: "")
    @Published var dynamicLinkTripDataShow: Bool = false
    @Published var showTripDetailsFromLink = false
    @Published var trainLeaveTimeType: TrainTimeType = .now
    @Published var leaveDate = Date()
    @Published var arriveDate = Date()
    @Published var appMessage = ""
    @Published var appLink = ""
    @Published var currentStationVersion:Int = 0
    @Published var serverStationVersion:Int = 0
    @Published var timeModalDisplayed: Bool = false
    
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    let net = Alamofire.NetworkReachabilityManager(host: "api.arrival.city")
    private let locationManager = CLLocationManager()
    private var lat = 0.0
    private var long = 0.0
    private var lastLat = 0.0
    private var lastLong = 0.0
    private var allowCycle = true
    private var netJSON: [String: Any?] = [:]
    private var settingsSuscriber: Any?
    private var authSubscriber: Any?
    private var leaveTimeSubscriber: Any?
    private var prioritizeLineSubscriber: Any?
    private var closestStationsSuscriber: Any?
    private var initialTrainsTrace: Trace?
    private var lastShownReviewCard = ""
    private var daysBetweenReviewAsk = 7
    private var initialTrainsTraceDone: Bool = false
    private var betaAPI = false
    private let settings = RemoteConfigSettings()
     private var apiUrl =  "https://api.arrival.city"
  //  private var apiUrl = "http://192.168.1.70:3000"
    
    override init() {
        super.init()
        print("init function")
        if (betaAPI) {
            self.apiUrl = "http://192.168.1.70:3000"
        }
        settings.minimumFetchInterval = 43200
        
        #if DEBUG
        self.debug = true
        #endif
        
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        if (!betaAPI) {
            self.apiUrl = self.remoteConfig["apiurl"].stringValue!
        }
        
        self.cycleTimer = Double(self.remoteConfig["cycleTimer"].stringValue!)!
        self.aboutText = self.remoteConfig["aboutText"].stringValue!
        self.realtimeTripNotice = self.remoteConfig["realtimeTripsNotice"].stringValue!
        self.privacyPolicy = self.remoteConfig["privacyPolicyUrl"].stringValue!
        self.termsOfService = self.remoteConfig["termsOfServiceUrl"].stringValue!
        self.appMessage = self.remoteConfig["inAppMessage"].stringValue ?? ""
        self.appLink = self.remoteConfig["inAppLink"].stringValue ?? ""
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
        print(getRouteData("1"))
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block config")
                        print(self.remoteConfig["apiurl"].stringValue, "remote config api value")
                        print(self.remoteConfig["onboarding1Heading"].stringValue, "remote config onboarding1Heading value")
                        if (!self.betaAPI) {
                            self.apiUrl = self.remoteConfig["apiurl"].stringValue!
                        }
                        
                        self.onboardingMessages["onboarding1Heading"] = JSON(self.remoteConfig["onboarding1Heading"].stringValue!)
                        self.onboardingMessages["onboarding2Heading"] = JSON(self.remoteConfig["onboarding2Heading"].stringValue!)
                        self.onboardingMessages["onboarding3Heading"] = JSON(self.remoteConfig["onboarding3Heading"].stringValue!)
                        self.onboardingMessages["onboarding4Heading"] = JSON(self.remoteConfig["onboarding4Heading"].stringValue!)
                        self.onboardingMessages["onboarding1Tagline"] = JSON(self.remoteConfig["onboarding1Tagline"].stringValue!)
                        self.onboardingMessages["onboarding2Tagline"] = JSON(self.remoteConfig["onboarding2Tagline"].stringValue!)
                        self.onboardingMessages["onboarding3Tagline"] = JSON(self.remoteConfig["onboarding3Tagline"].stringValue!)
                        self.onboardingMessages["onboarding4Tagline"] = JSON(self.remoteConfig["onboarding4Tagline"].stringValue!)
                        print(self.onboardingMessages.dictionaryObject, "config  onboarding messages")
                        self.onboardingLoaded = true
                        self.aboutText = self.remoteConfig["aboutText"].stringValue!
                        self.realtimeTripNotice = self.remoteConfig["realtimeTripsNotice"].stringValue!
                        self.leaveTrainRealtimeNotice = self.remoteConfig["leaveTrainRealtimeNotice"].stringValue!
                        self.daysBetweenReviewAsk = Int(self.remoteConfig["daysBetweenReviewAsk"].stringValue!)!
                        self.privacyPolicy = self.remoteConfig["privacyPolicyUrl"].stringValue!
                        self.termsOfService = self.remoteConfig["termsOfServiceUrl"].stringValue!
                        self.appMessage = self.remoteConfig["inAppMessage"].stringValue!
                        self.appLink = self.remoteConfig["inAppLink"].stringValue!
                        print(self.onboardingLoaded, "config onboarding loaded")
                        if (!defaults.bool(forKey: "shownDetailOnBoard") && self.remoteConfig["showTripDetailFeature"].boolValue || self.debug) {
                            self.showTripDetailFeature = true
                        } else {
                            self.showTripDetailFeature = false
                        }
                        
                        
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
        
        net?.listener = { status in
            print("network status from listener:", self.net?.isReachable, status, self.net?.flags)
            if let unwrapped = self.net?.isReachable {
                print("network unwrapped", unwrapped)
                self.network = unwrapped
            } else {
                print("network no value")
                self.network = false
            }
            
            
        }
        
        
        
    }
    func showTripDetailsFromLink(_ tripId: String) {
        self.dynamicLinkTripDataShow = false
        print(tripId, "dynamic link on load")
        self.showTripDetailsFromLink = true
        let headers: HTTPHeaders = [
            "Authorization": self.passphrase,
            "Accept": "application/json"
        ]
        Analytics.logEvent("showing_trip_link", parameters: [:])
        Alamofire.request(apiUrl + "/api/v3/trip/" + tripId, headers: headers).responseJSON { response in
            print("dynamic link trip data:", JSON(response.value))
            if let error = JSON(response.value)["error"].string {
                self.showTripDetailsFromLink = false
            } else {
                let trip = JSON(response.value)["trip"]
                var routes: [String: Route] = [:]
                for (id, route) in JSON(response.value)["routes"].dictionaryObject! {
                    //  print(id, route)
                    let routeJSON = JSON(route)
                    let stations = routeJSON["config"]["station"].arrayValue.map { $0.stringValue}
                    //  print(stations, "route stations")
                    routes[id] = Route(name: routeJSON["name"].stringValue, abbr: routeJSON["abbr"].stringValue, routeID: routeJSON["routeID"].stringValue, origin: routeJSON["origin"].stringValue, destination: routeJSON["destination"].stringValue, direction: routeJSON["direction"].stringValue, color: routeJSON["color"].stringValue, stations: stations)
                }
                let originDate = trip["@origTimeDate"].stringValue
                let destDate = trip["@destTimeDate"].stringValue
                
                let originTime = moment(trip["@origTimeMin"].stringValue + " " + originDate, dateFormateDate)
                let now = moment()
                let difference = originTime.diff(now, "minutes").intValue
                var legs: [Leg] = []
                for i in 0...trip["leg"].arrayValue.count - 1 {
                    let leg = trip["leg"].arrayValue[i]
                    let legRoute = routes[leg["route"].stringValue]!
                    let origin = self.stationsByAbbr[leg["@origin"].stringValue]!.name
                    let destination = self.stationsByAbbr[leg["@destination"].stringValue]!.name
                    var type: String
                    if (i == trip["leg"].arrayValue.count - 1) {
                        type = "destination"
                    } else if (i == 0) {
                        type = "board"
                    }   else {
                        type = "transfer"
                    }
                    let fromStationIndex = legRoute.stations.firstIndex(of: leg["@origin"].stringValue)
                    let toStationIndex = legRoute.stations.firstIndex(of: leg["@destination"].stringValue)
                    
                    
                    
                    //TODO Make this smarter with more graceful fallbacks
                    
                    var stopCount = 0
                    if let toStationIndex = toStationIndex {
                        if let fromStationIndex = fromStationIndex {
                            stopCount = abs(toStationIndex - fromStationIndex)
                        }
                        
                    }
                    var transferWait: String?
                    if (i != 0) {
                        let lastTrainString = trip["leg"][i - 1]["@destTimeMin"].stringValue
                        let originTimeString = leg["@origTimeMin"].stringValue
                        let lastTrainTime = moment(lastTrainString + " " + trip["leg"][i - 1]["@destTimeDate"].stringValue, dateFormateDate)
                        let originTime = moment(originTimeString + " " + leg["@origTimeDate"].stringValue, dateFormateDate)
                        let difference = originTime.diff(lastTrainTime, "minutes")
                        transferWait = difference.stringValue + " min"
                        print(lastTrainTime.format(), originTime.format(), difference, transferWait, "transfer wait")
                    }
                    let enrouteTime = moment(leg["@destTimeMin"].stringValue  + " " + leg["@destTimeDate"].stringValue, dateFormateDate).diff(moment(leg["@origTimeMin"].stringValue + " " + leg["@origTimeDate"].stringValue, dateFormateDate), "minutes")
                    let enrouteTimeString = enrouteTime.stringValue + " min"
                    print(leg["@destTimeMin"].stringValue  + " " + leg["@destTimeDate"].stringValue, dateFormateDate, "leg time")
                    print(leg["@origTimeMin"].stringValue  + " " + leg["@origTimeDate"].stringValue, dateFormateDate, "leg time")
                    legs.append(Leg(order: leg["@order"].intValue, origin:origin, destination: destination, originTime: leg["@origTimeMin"].stringValue, originDate: leg["@origTimeDate"].stringValue, destinationTime: leg["@destTimeMin"].stringValue, destDate: leg["@destTimeDate"].stringValue, line: leg["@line"].stringValue, route: leg["route"].intValue, trainDestination: leg["@trainHeadStation"].stringValue, color: legRoute.color, stops: stopCount, type: type, enrouteTime: enrouteTimeString, transferWait: transferWait))
                    
                }
                self.dynamicLinkTripData = TripInfo(origin: trip["@origin"].stringValue, destination: trip["@destination"].stringValue, legs: legs, originTime: trip["@origTimeMin"].stringValue, originDate: trip["@origTimeDate"].stringValue, destinatonTime: trip["@destTimeMin"].stringValue, destinatonDate: trip["@destTimeDate"].stringValue, tripTIme: trip["@tripTime"].doubleValue, leavesIn: difference, tripId: trip["tripId"].stringValue)
                print(self.dynamicLinkTripData, "dynamic link trip data")
                self.dynamicLinkTripDataShow = true
            }
            
        }
        
        
    }
    func hideDetailCard() {
        self.showTripDetailFeature = false
        defaults.set(true, forKey: "shownDetailOnBoarding")
    }
    func showReviewCard() {
        print("lastShownReviewCard", self.lastShownReviewCard)
        if (self.lastShownReviewCard.isEmpty || moment.utc(lastShownReviewCard).isBefore(moment().subtract(self.daysBetweenReviewAsk, "days"))) {
            self.reviewCard = true
            print("lastShownReviewCard is beofre last time")
        } else {
            self.reviewCard = false
            print("lastShownReviewCard is bnot beofre last time")
        }
        // self.reviewCard = true
        
    }
    func hideReviewCard() {
        self.reviewCard = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let user = data.value(forKey: "pass") {
                    print(user as! String)
                    if (user as! String == self.passphrase) {
                        data.setValue(moment.utc().toString(), forKey: "reviewCardLastShown")
                    }
                }
                
            }
            do {
                try context.save()
            } catch {
                
            }
        } catch {
            
        }
    }
    func testNetwork() {
        print("network status:", self.net?.isReachable)
        if let unwrapped = self.net?.isReachable {
            print("network unwrapped", unwrapped)
            self.network = unwrapped
        } else {
            print("network no value")
            self.network = false
        }
        //self.networkTestStatus = "checking..."
        /*
         self.networkTestStatus = "checking..."
         print("network testing")
         let headers: HTTPHeaders = [
         "Authorization": self.passphrase,
         "Accept": "application/json"
         ]
         Alamofire.request(apiUrl, headers: headers).response { response in
         print("network Test", response.error, response.error)
         self.network = response.error == nil
         if (!self.network) {
         self.networkTestStatus = "test failed"
         }
         }*/
        
        
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
        case "red", "RD-N".lowercased(), "RD-S".lowercased():
            return Color.red
        case "yellow", "yl-n",  "YL-S".lowercased() :
            return Color.yellow
        case "green", "GN-S".lowercased(), "GN-N".lowercased() :
            return Color.green
        case "orange", "OR-N".lowercased(),  "OR-S".lowercased() :
            return Color.orange
        case "purple", "PR-N".lowercased(), "PR-S".lowercased() :
            return Color.purple
        case "blue", "BL-N".lowercased(),  "BL-S".lowercased() :
            return Color.blue
        case "white","WT-N".lowercased(), "WT-S".lowercased() :
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
        if (station.name != "none") {
            // self.trainLeaveTimeType = .now //just for before release of full time modes
            if (self.trainLeaveTimeType == .arrive) {
                self.trainLeaveTimeType = .now
            }
            let day = Calendar.current.component(.weekday, from: Date())
            let hour = Calendar.current.component(.hour, from: Date())
            
            let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: context)!
            let trip = NSManagedObject(entity: tripEntity, insertInto: context)
            trip.setValue(self.fromStation.abbr, forKeyPath: "fromStation")
            trip.setValue(self.toStation.abbr, forKeyPath: "toStation")
            trip.setValue(day, forKeyPath: "day")
            trip.setValue(hour, forKeyPath: "hour")
            trip.setValue(self.passphrase, forKeyPath: "user")
            
            do {
                try context.save()
                computeToSuggestions()
            } catch let error as NSError {
                print(error)
            }
        } else {
            if (self.trainLeaveTimeType == .arrive) {
                self.trainLeaveTimeType = .now
            }
        }
        Analytics.logEvent("set_toStation", parameters: [
            "station": station.abbr as NSObject,
            "fromStation": self.fromStation.abbr as NSObject
        ])
        
        
    }
    @objc func cylce() {
        let cycleLeaveType = self.trainLeaveTimeType
        self.testNetwork()
        // print(self.leaveDate, "leave time")
        getClosestStations()
        if (self.fromStation.name != "loading" && self.auth && self.ready && !self.passphrase.isEmpty && allowCycle) {
            
            print("cycling", self.passphrase)
            if (self.toStation.id == "none" ) {
                print("fetching trains from", self.fromStation.abbr)
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                var requestType = "now"
                var time = "now"
                if (cycleLeaveType == .leave) {
                    requestType = "leave"
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone(identifier: "PST")
                    formatter.dateFormat = "dd-MM-yyyy hh:mm a"
                    time = formatter.string(from: self.leaveDate) ?? "unknown"
                    print(self.leaveDate, "leave date", time)
                }
                Alamofire.request( apiUrl + "/api/v3/trains/" + self.fromStation.abbr, method: .post, parameters: ["type": requestType, "time": time], headers: headers).responseJSON { response in
                    // print(JSON(response.value))
                    let estimates = JSON(JSON(response.value)["estimates"]["etd"].arrayValue)
                    //   print(estimates.count)
                    
                    //TODO Fix error handeling
                    if (estimates.count > 0) {
                        var results: Array = [Train]()
                        var northResults: Array = [Train]()
                        var southResults: Array = [Train]()
                        if (cycleLeaveType == .leave) {
                            requestType = "leave"
                            //  print(estimates, estimates.count, "leave estimates")
                            for i in 0...estimates.count - 1 {
                                let thisTrain = estimates[i]
                                //  print(thisTrain)
                                let destination = thisTrain["destination"].stringValue
                                let time = thisTrain["time"].stringValue
                                let bikeFlag = thisTrain["bikeFlag"].stringValue
                                let load = thisTrain["load"].stringValue
                                let route = thisTrain["route"].stringValue
                                // print("route", route)
                                let routeData = getRouteData(route)
                                let direction = routeData.direction
                                let color = routeData.color
                                let hexColor = routeData.hexColor
                                let train = Train(id: UUID(), direction: destination, time: time, unit: "", color: color, hex: hexColor, eta: "")
                                print(train)
                                results.append(train)
                                if direction == "North" {
                                    northResults.append(train)
                                } else {
                                    southResults.append(train)
                                }
                            }
                        } else if (cycleLeaveType == .now) {
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
                        
                        
                    } else {
                        self.loaded = true
                        self.noTrains = true
                        
                    }
                }
            } else {
                print("fetching trips from", self.fromStation.abbr, "to", self.toStation.abbr )
                let headers: HTTPHeaders = [
                    "Authorization": self.passphrase,
                    "Accept": "application/json"
                ]
                var requestType = "now"
                var time = "now"
                if (cycleLeaveType == .leave) {
                    requestType = "leave"
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone(identifier: "PST")
                    formatter.dateFormat = "dd-MM-yyyy hh:mm a"
                    time = formatter.string(from: self.leaveDate) ?? "unknown"
                    print(self.leaveDate, "leave date", time)
                }
                if (cycleLeaveType == .arrive) {
                    requestType = "arrive"
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone(identifier: "PST")
                    formatter.dateFormat = "dd-MM-yyyy hh:mm a"
                    time = formatter.string(from: self.arriveDate) ?? "unknown"
                    print(self.arriveDate, "leave date", time)
                }
                print("v4 route", time, requestType)
                print(apiUrl + "/api/v4/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr)
                Alamofire.request(apiUrl + "/api/v4/routes/" + self.fromStation.abbr + "/" + self.toStation.abbr, method: .post, parameters: ["type": requestType, "time": time], headers: headers).responseJSON { response in
                    
                    
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
                                    //TODO Make this smarter with more graceful fallbacks
                                    
                                    var stopCount = 0
                                    if let toStationIndex = toStationIndex {
                                        if let fromStationIndex = fromStationIndex {
                                            stopCount = abs(toStationIndex - fromStationIndex)
                                        }
                                        
                                    }
                                    
                                    
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
                                        let lastTrainTime = moment(lastTrainString + " " + thisTrain["leg"][i - 1]["@destTimeDate"].stringValue, dateFormateDate)
                                        let originTime = moment(originTimeString + " " + leg["@origTimeDate"].stringValue, dateFormateDate)
                                        let difference = originTime.diff(lastTrainTime, "minutes")
                                        transferWait = difference.stringValue + " min"
                                        print(lastTrainTime.format(), originTime.format(), difference, transferWait, "transfer wait")
                                    }
                                    let enrouteTime = moment(leg["@destTimeMin"].stringValue  + " " + leg["@destTimeDate"].stringValue, dateFormateDate).diff(moment(leg["@origTimeMin"].stringValue + " " + leg["@origTimeDate"].stringValue, dateFormateDate), "minutes")
                                    let enrouteTimeString = enrouteTime.stringValue + " min"
                                    print(leg["@destTimeMin"].stringValue  + " " + leg["@destTimeDate"].stringValue, dateFormateDate, "leg time")
                                    print(leg["@origTimeMin"].stringValue  + " " + leg["@origTimeDate"].stringValue, dateFormateDate, "leg time")
                                    // print(routeJSON.dictionaryObject, "route for route", routeNum, "color", routeJSON["color"].stringValue)
                                    
                                    legs.append(Leg(order: leg["@order"].intValue, origin: origin, destination: destination, originTime: leg["@origTimeMin"].stringValue, originDate: leg["@origTimeDate"].stringValue, destinationTime: leg["@destTimeMin"].stringValue, destDate: leg["@origTimeDate"].stringValue, line: leg["@line"].stringValue, route: leg["route"].intValue, trainDestination: leg["@trainHeadStation"].stringValue,  color:routeJSON.color, stops: stopCount, type: type, enrouteTime: enrouteTimeString, transferWait: transferWait))
                                } else {
                                    print("route for route", routeNum, leg, "doesn't exist")
                                }
                                
                                
                            }
                            //let color = thisTrain["color"].stringValue
                            let color = "none"
                            print(eta)
                            let originDate = thisTrain["@origTimeDate"].stringValue
                            let destDate = thisTrain["@destTimeDate"].stringValue
                            
                            let originTime = moment(thisTrain["@origTimeMin"].stringValue + " " + originDate, dateFormateDate)
                            let now = moment()
                            let difference = originTime.diff(now, "minutes").intValue
                            print("route v4", originTime, etd, difference)
                            if (difference >= 0) {
                                results.append(Train(id: UUID(), direction: direction, time: etd, unit: "", color: "none", cars: 0, hex: "0", eta: eta))
                                trips.append(TripInfo(origin: self.fromStation.abbr, destination: direction, legs: legs, originTime: thisTrain["@origTimeMin"].stringValue, originDate: originDate, destinatonTime: thisTrain["@destTimeMin"].stringValue, destinatonDate: destDate, tripTIme: thisTrain["@tripTime"].doubleValue, leavesIn: difference, tripId: thisTrain["tripId"].stringValue))
                            }
                            
                        }
                        
                        results.sort {
                            $0.time < $1.time
                        }
                        if (results.count >= 1) {
                            self.noTrains = false
                            self.trains = results
                            self.trips = trips
                            self.loaded = true
                        } else {
                            self.loaded = true
                            self.noTrains = true
                        }
                        
                        
                    } else {
                        self.loaded = true
                        self.noTrains = true
                        
                    }
                }
            }
            
        } else {
            print("cycling failed due to invalid data")
            let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(cylce), userInfo: nil, repeats: false)
            
        }
        
    }
    func  requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    private func start() {
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
        leaveTimeSubscriber = $timeModalDisplayed.sink {value in
            if (value == false) {
                self.loaded = false
                self.cylce()
            }
        
        }
        authSubscriber = $passphrase.sink {value in
            print(value, "auth subscriber")
            if (self.auth) {
                if (self.remoteConfig["asktoreview"].boolValue || self.debug) {
                    self.showReviewCard()
                } else {
                    print("no show review card")
                }
                
                
                print("passphrase changed and auth settings from auth", value)
                
                self.computeToSuggestions(pass: value)
                print("default setting" + String(defaults.bool(forKey: "defaultsEnabled")))
                if (!defaults.bool(forKey: "defaultsEnabled")) {
                    print("defaults off")
                    let managedContext =  appDelegate.persistentContainer.viewContext
                    let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Preferences")
                    do {
                        
                        let result = try managedContext.fetch(fetchRequest)
                        if (!result.isEmpty) {
                            print("fetching settings from auth")
                            for data in result as! [NSManagedObject] {
                                
                                var sortTrainsByTimeSetting = false
                                if let user = data.value(forKey: "user") {
                                    if (user as! String == value) {
                                        if  let tempSetting = data.value(forKey: "sortTrainsByTime") {
                                            print("sortTrainsByTime setting", tempSetting)
                                            if (tempSetting as! Bool) {
                                                self.sortTrainsByTime = true
                                                defaults.set(true, forKey: "sortTrainsByTime")
                                                defaults.set(true, forKey: "defaultsEnabled")
                                                print("sortTrainsByTime settings result true")
                                                print("defualts set", String(defaults.bool(forKey: "defaultsEnabled") ))
                                            } else {
                                                self.sortTrainsByTime = false
                                                defaults.set(false, forKey: "sortTrainsByTime")
                                                defaults.set(true, forKey: "defaultsEnabled")
                                                print("defualts set", String(defaults.bool(forKey: "defaultsEnabled") ))
                                                print("sortTrainsByTime settings result false")
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                                
                            }
                        } else {
                            self.sortTrainsByTime = false
                        }
                        
                        
                    } catch {
                        print("failed to get settings")
                        
                    }
                } else {
                    print("defaults enabled")
                }
            }
        }
        
        settingsSuscriber = $sortTrainsByTime.sink {value in
            print(value, "settings change")
            if (self.auth && !self.passphrase.isEmpty){
                Analytics.setUserProperty(String(value), forName: "sortTrainsByTime")
                defaults.set(value, forKey: "sortTrainsByTime")
                defaults.set(true, forKey: "defaultsEnabled")
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
        if (!self.stations.isEmpty && lat != 0.0 && long != 0.0) {
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
            print("getting nearest station FAILED due to lack of info", self.stations.isEmpty)
        }
    }
    func getStationsFromApi() {
        print("getting stations from api", apiUrl)
        Alamofire.request(apiUrl + "/api/v3/stations")
            .responseJSON{
                response in print(response)
                if  response.value != nil {
                    let stationJSON = JSON(response.value)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationModel")
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    var stationsList: [Station] = []
                    self.stations = []
                    self.stationsByAbbr = [:]
                    print("requesting stations v", stationJSON["version"].intValue)
                    for i in 0..<stationJSON["stations"].arrayValue.count {
                        let json = stationJSON["stations"][i]
                        let id = json["_id"].stringValue
                        let name = json["name"].stringValue
                        let abbr = json["abbr"].stringValue
                        let lat = json["gtfs_latitude"].doubleValue
                        let long = json["gtfs_longitude"].doubleValue
                        stationsList.append(Station(id: id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue))
                        /* let entity = NSEntityDescription.entity(forEntityName: "StationModel", in: context)
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
                         } */
                        self.stations.append(Station(id:id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue))
                        self.stationsByAbbr[abbr] = Station(id:id, name: name, lat: lat, long: long, abbr: abbr, version: stationJSON["version"].intValue)
                    }
                    print(stationsList)
                    do {
                        try Disk.save(stationsList, to: .applicationSupport, as: "stations.json")
                        try Disk.save(self.stationsByAbbr, to: .applicationSupport, as: "stationsByAbbr.json")
                    } catch {
                        print("error saving data")
                    }
                    //   print(self.stations)
                    self.fromStationSuggestions = self.stations
                    self.currentStationVersion = self.stations[0].version
                    print("got stations from server version", self.stations[0].version)
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
            let retrievedStationList = try Disk.retrieve("stations.json", from: .applicationSupport, as: [Station].self)
            let retrievedStationListByABBR = try Disk.retrieve("stationsByAbbr.json", from: .applicationSupport, as: [String: Station].self)
            if (retrievedStationList.count >= 1 && retrievedStationListByABBR.count >= 1) {
                print(retrievedStationList, retrievedStationListByABBR, "retrived station list")
                self.stations = retrievedStationList
                self.stationsByAbbr = retrievedStationListByABBR
                self.currentStationVersion = self.stations[0].version
                print("got stations", self.stations[0].version, self.serverStationVersion)
                self.fromStationSuggestions = self.stations
                getClosestStations()
                self.evaluateStationVersions()
                
            } else {
                print("unable to retrive station list")
                getStationsFromApi()
            }
            /*
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
             //print(stations, version)
             if (stations.isEmpty) {
             print("no coredata stations")
             getStationsFromApi()
             } else {
             self.stations = stations
             self.fromStationSuggestions = self.stations
             print("got stations from core data")
             getClosestStations()
             }
             */
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
        
        defaults.set(true, forKey: "defaultsEnabled")
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
                    defaults.set(passphrase, forKey: "passphrase")
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
    func evaluateStationVersions() {
        if (self.currentStationVersion != 0 && self.serverStationVersion != 0) {
            if (self.currentStationVersion != self.serverStationVersion) {
                print(" stations no version match", self.currentStationVersion, self.serverStationVersion)
                getStationsFromApi()
                getClosestStations()
            } else {
                print("stations up to date")
            }
        } else {
            print("request to check station version not fufilled,")
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
                            if (jsonResponse["stationVersion"].intValue != nil) {
                                print("set server stations version", jsonResponse["stationVersion"].intValue)
                                self.serverStationVersion = jsonResponse["stationVersion"].intValue
                                self.evaluateStationVersions()
                                
                                
                            } else {
                                print("no server stations version data", jsonResponse["stationVersion"].stringValue)
                            }
                            if let reviewCardLastShown = nsResult[0].value(forKey: "reviewCardLastShown") {
                                self.lastShownReviewCard = reviewCardLastShown as! String
                                print("lastShownReviewCard", reviewCardLastShown)
                            } else {
                                print("reviewCardLastShown none")
                            }
                            
                            self.passphrase = passphraseToTest
                            defaults.set(passphraseToTest, forKey: "passphrase")
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
