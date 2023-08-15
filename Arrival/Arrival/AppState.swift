//
//  AppState.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import ArrivalCore
import ArrivalGTFS
import SwiftUI
@MainActor
public class AppState: ObservableObject {
    @Published var arrivals: [Arrival] = []
    @Published var realtimeStopTimes: [String: TransitRealtime_TripUpdate.StopTimeUpdate] = [:]
    @Published var realtimeTrips: [String: Trip] = [:]
    
    @Published var fromStationChooser = false
    @Published var toStationChooser = false
    @Published var arrivalToDisplay: Arrival? = nil
    
    @Published var cycling = false
    
    @Published var fromStation: Stop? = nil
    @Published var toStation: Stop? = nil
    
    @Published var stations: [Stop] = []
    @Published var toStationSuggestions: [Stop] = []
    
    var lastServerFetch: Date = Date(timeIntervalSince1970: 0)
    
    var timer: Timer!
    
    @MainActor
    func handleRTUpdates() {
        DispatchQueue.main.sync {
            withAnimation {
                self.realtimeTrips = ArrivalDataManager.shared.realtimeTrips
                self.realtimeStopTimes = ArrivalDataManager.shared.realtimeStopTimes
                self.sortArrivals()
            }
        }
        
    }
    func setup() async {
        await ArrivalDataManager.shared.loadData()
        ArrivalDataManager.shared.rtUpdateHandler = {
            print("rt update")
            self.handleRTUpdates()
            
        }
        self.stations = ArrivalDataManager.shared.stations.all
        self.fromStation = ArrivalDataManager.shared.stations.byStopID("ROCK")!
       // self.toStation = ArrivalDataManager.shared.stations.byStopID("WARM")!
        await self.cycle()
       // self.arrivalToDisplay = self.arrivals.first
        self.startTimer()
        self.calculateToStationSuggestions()
        let alerts  = try? await ArrivalDataManager.shared.rt.getAlerts()
        await ArrivalDataManager.shared.downloadRoutes()
       
    }
    func startTimer() {
        self.timer = .scheduledTimer(withTimeInterval: 30, repeats: true, block: {timer in
            Task {
                await self.cycle()
            }
        })
    }
    @MainActor
    public func cycle() async {
        self.cycling = true
        if (self.lastServerFetch.timeIntervalSinceNow < -(60 * 5)) {
            self.arrivals = []
        }
        if (self.fromStation != nil && self.toStation == nil) {
           await self.cycleFetchTrains()
        } else if (self.fromStation != nil && self.toStation != nil) {
            await self.cycleFetchPlans()
         }
        print("arrivals", self.arrivals.count)
       await ArrivalDataManager.shared.rt.update()
        self.cycling = false
       
    }
    func cycleFetchPlans() async {
        if (self.lastServerFetch.timeIntervalSinceNow < -120 || self.arrivals.count == 0) {
         
            guard let fromStation = fromStation else {
                return
            }
            guard let toStation = toStation else {
                return
            }
             
            print("fetching fresh arrivals")
            let res = await ArrivalDataManager.shared.tripPlans(from: fromStation, to: toStation, at: .now)
            print(res)
            withAnimation {
                self.arrivals = res
            }
            self.sortArrivals()
            self.lastServerFetch = .now
           
        } else {
            print("using cached arrivals")
            self.arrivals = arrivals.filter({a in
                var aTime: Date = Date()
               
                switch a.type {
                case .train(let train):
                    aTime = Date(bartTime: train.stopTime.departureTime) + TimeInterval(self.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)
                    
                case .tripPlan(let plan):
                    aTime = (plan.connections.first?.startTime ?? Date()) + TimeInterval(self.realtimeStopTimes[plan.connections.first?.startStopTimeId ?? ""]?.arrival.delay ?? 0)
                }
                return aTime > .now - 30
            })
        }
        
    }
    func cycleFetchTrains() async {
        if (self.lastServerFetch.timeIntervalSinceNow < -120 || self.arrivals.count == 0) {
         
            guard let fromStation = fromStation else {
                return
            }
            
             
            print("fetching fresh arrivals")
            let res = await ArrivalDataManager.shared.trains(from: fromStation, at: .now)
            print(res)
            withAnimation {
                self.arrivals = res
            }
            self.sortArrivals()
            self.lastServerFetch = .now
           
        } else {
            print("using cached arrivals")
            self.arrivals = arrivals.filter({a in
                var aTime: Date = Date()
               
                switch a.type {
                case .train(let train):
                    aTime = Date(bartTime: train.stopTime.departureTime) + TimeInterval(self.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)
                    
                case .tripPlan(let plan):
                    aTime = (plan.connections.first?.startTime ?? Date()) + TimeInterval(self.realtimeStopTimes[plan.connections.first?.startStopTimeId ?? ""]?.arrival.delay ?? 0)
                }
                return aTime > .now - 30
            })
        }
    }
    
    func sortArrivals() {
        self.arrivals = arrivals.sorted(by: { a, b in
            var aTime: Date = Date()
            var bTime: Date = Date()
            switch a.type {
            case .train(let train):
                aTime = Date(bartTime: train.stopTime.departureTime) + TimeInterval(self.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)
                
            case .tripPlan(let plan):
                aTime = (plan.connections.first?.startTime ?? Date()) + TimeInterval(self.realtimeStopTimes[plan.connections.first?.startStopTimeId ?? ""]?.arrival.delay ?? 0)
            }
            
            switch b.type {
            case .train(let train):
                bTime = Date(bartTime: train.stopTime.departureTime) + TimeInterval(self.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)
                
            case .tripPlan(let plan):
                bTime = (plan.connections.first?.startTime ?? Date()) + TimeInterval(self.realtimeStopTimes[plan.connections.first?.startStopTimeId ?? ""]?.arrival.delay ?? 0)
            }
            return aTime < bTime
        }).filter({a in
            var aTime: Date = Date()
           
            switch a.type {
            case .train(let train):
                aTime = Date(bartTime: train.stopTime.departureTime) + TimeInterval(self.realtimeStopTimes[train.stopTime.id]?.arrival.delay ?? 0)
                
            case .tripPlan(let plan):
                aTime = (plan.connections.first?.startTime ?? Date()) + TimeInterval(self.realtimeStopTimes[plan.connections.first?.startStopTimeId ?? ""]?.arrival.delay ?? 0)
            }
            return aTime > .now - 30
        })
    }
    func updateFromStation(_ station: Stop) async {
        self.arrivals = []
        guard self.fromStation != station else {
            self.lastServerFetch = .distantPast
            await self.cycle()
                return
        }
        if (station == self.toStation) {
            self.toStation = nil
        }
        self.fromStation = station
        self.lastServerFetch = .distantPast
        await self.cycle()
        self.calculateToStationSuggestions()
    }
    func setToStation(_ station: Stop?) async {
        guard self.fromStation != station else {
            return
        }
        guard self.toStation != station else {
            self.lastServerFetch = .distantPast
            await self.cycle()
                return
        }
        self.arrivals = []
        self.lastServerFetch = .distantPast
        self.toStation = station
        await self.cycle()
    }
    func calculateToStationSuggestions() {
        var working = self.stations.filter({station in
            return station != self.fromStation
        })
        if let toStation = self.toStation {
            working = working.sorted(by: {(a, b) in
                return a == toStation
            })
        }
        self.toStationSuggestions = working
    }
}
