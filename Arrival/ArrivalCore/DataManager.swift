//
//  DataManager.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import ArrivalGTFS


public class ArrivalDataManager {
    public static let shared = ArrivalDataManager()
    
    private var disk = ArrivalDiskManager()
    private var api = ArrivalAPIManager()
    public var rt = RTManager()
    
    public var rtUpdateHandler: ()->() = {}
    
    public var stations: StationsDB = StationsDB(from: [])
    
    public var realtimeStopTimes: [String: TransitRealtime_TripUpdate.StopTimeUpdate] = [:]
    public var realtimeTrips: [String: Trip] = [:]
    
    public var tripDoesntExistCache: [String: Int] = [:]
    
 //   private var stopTimesforTrip:[String: [StopTime]] = [:]
    private var localStopTimes: StopTimesDB = StopTimesDB(from: [])
    private var localTrips: TripsDB = TripsDB(from: [], stopTimes: [])
    private var localRoutes: RoutesDB = RoutesDB(from: [], trips: TripsDB(from: [], stopTimes: []), stations: StationsDB(from: []))
    private var calendar: GTFSCalendarDB = GTFSCalendarDB(from: [])
    
    private init(localStations: StationsDB, localStopTimes: StopTimesDB, localTrips: TripsDB, localRoutes: RoutesDB) {
        self.stations = localStations
        self.localStopTimes = localStopTimes
        self.localTrips = localTrips
        self.localRoutes = localRoutes
    }
    private init() {
        
    }
    public func loadData() async {
        self.rt.setHandler(handle: self.handleRTUpdate(_:))
        self.stations = disk.stationsDB()
        if (self.stations.all.count == 0) {
            do {
            let db = try await self.api.stationsDB()
                print("fetched from api")
                self.stations = db
                self.disk.updateStationsDB(db)
            } catch {
                print("error", error)
            }
        }
        print("init with", self.stations.all.count)
    }
    
    public func route(id: String) async -> Route? {
        guard self.localRoutes.byRouteID(id) == nil else {
            return self.localRoutes.byRouteID(id)
        }
        await self.downloadRoutes()
        return self.localRoutes.byRouteID(id)
       
    }
    public func route(stopId: String) async -> [Route] {
        guard self.localRoutes.byStopID(stopId) == nil else {
            print("local route option")
            return self.localRoutes.byStopID(stopId) ?? []
        }
        print("needs to download routes")
        await self.downloadRoutes()
        print("downloaded routes now returning")
        return self.localRoutes.byStopID(stopId) ?? []
       
    }
    
    public func trains(from station: Stop, at: Date) async -> [Arrival] {
        do {
            let result = try await self.api.trains(from: station, at: at)
            return result.stopTimes.map {time in
                self.localTrips.insert(result.trips[time.tripId]!, stopTimes: self.localStopTimes.all)
                return Arrival(type: .train(.init(stopTime: time, trip: result.trips[time.tripId]!, route: result.routes[result.trips[time.tripId]!.routeId]!)))
            }
        } catch {
            print(error)
            return []
        }
    }
    public func tripPlans(from: Stop, to: Stop, at: Date) async -> [Arrival] {
        do {
            let result = try await self.api.tripPlan(from: from, to: to, at: at)
          //  self.localStopTimes.insert(result.stopTimes)
            self.localStopTimes.insert(Array(result.stopTimes.values))
            result.trips.values.forEach({trip in
                self.localTrips.insert(trip, stopTimes: self.localStopTimes.all)
            })
            //self.localRoutes = RoutesDB(from: self.localRoutes.all + Array(result.routes.values), trips: self.localTrips, stations: self.stations)
            return result.connections.compactMap {connection in
                guard connection.count > 0 else {
                    print("ERROR", connection)
                    return nil
                }
                return Arrival(type: .tripPlan(.init(connections: connection)))
            }
        } catch {
            print(error)
            return []
        }
    }
    public func trip(tripId: String) async -> Trip? {
        if let local = self.localTrips.byTripID(tripId) {
           // print("local trip exists")
            return local
        } else {
            guard self.tripDoesntExistCache[tripId] ?? 0 <= 2 else {
               // print("auto assume trip doesn't exist")
                return nil
            }
            guard let trip = try? await self.api.trip(tripId: tripId).trip else {
              //  print("api couldn't find trip")
                self.tripDoesntExistCache[tripId] = (self.tripDoesntExistCache[tripId] ?? 0) + 1
                return nil
                
            }
           // print("api trip")
            self.localTrips.insert(trip, stopTimes: self.localStopTimes.all)
            return trip
        }
        
    }
    public func stopTimes(for tripId: String) async -> [StopTime] {
        print("getting stoptimes for", tripId)
        if let times = self.localStopTimes.byTripID(tripId) {
            print("stoptimes for \(tripId) local")
            return times
        } else {
            do {
                let times = try await self.api.stopTimes(for: tripId)
                print(times.stopTimes.count)
                self.localStopTimes.insert(times.stopTimes)
               // self.stopTimesforTrip[tripId] = times.stopTimes
                return times.stopTimes
            } catch {
                print(error)
                return []
            }
        }
    }
    public func stopTime(by id: String) async -> StopTime? {
        print("getting stopTime", id)
        if let time = self.localStopTimes.byStopTimeID(id) {
            print("stoptimes for \(id) local")
            return time
        } else {
            do {
                let time = try await self.api.stopTime(by: id)
                print(time)
                self.localStopTimes.insert(time.stopTime)
              //  self.stopTimesforTrip[tripId] = times.stopTimes
                return time.stopTime
            } catch {
                print(error)
                return nil
            }
        }
    }
    public func downloadRoutes() async {
        guard let all = try? await self.api.allRoutes() else {
            return
        }
        self.localRoutes = all.db
        self.disk.updateRoutesDB(self.localRoutes)
    }
    
     func handleRTUpdate(_ feedMessage: TransitRealtime_FeedMessage) async {
        self.realtimeTrips = [:]
        self.realtimeStopTimes = [:]
         //print(feedMessage)
         var rtStopTimes: [String: TransitRealtime_TripUpdate.StopTimeUpdate] = [:]
         var rtTrips: [String: Trip] = [:]
        for entity in feedMessage.entity {
            guard entity.hasTripUpdate else {
                continue
            }
            let update = entity.tripUpdate
           // print("handling", update)
           if var trip = await self.trip(tripId: update.trip.tripID) {
               trip.trainType = .init(rawValue: update.vehicle.label) ?? .unknown
               rtTrips[trip.tripId] = trip
           } else {
               print("RT Trip does not exist", update.trip.tripID)
           }
           
           update.stopTimeUpdate.forEach({stopTimeUpdate in
               guard stopTimeUpdate.hasStopID else {
                   return
               }
               guard stopTimeUpdate.hasStopSequence else {
                   return
               }
               let id = update.trip.tripID+stopTimeUpdate.stopID + String(stopTimeUpdate.stopSequence)
               print(id, stopTimeUpdate)
              
               rtStopTimes[id] = stopTimeUpdate
               print("added ", id)
           })
           
        }
         print(rtStopTimes)
         self.realtimeStopTimes = rtStopTimes
         self.realtimeTrips = rtTrips
        self.rtUpdateHandler()
      
        
         
    }
    
    
}

public struct Arrival: Identifiable {
   public var id: String {
        switch self.type {
        case .train(let train):
            return train.id+"train"
        case .tripPlan(let plan):
            return plan.id+"plan"
        }
    }
    public var arrivalTime: Date {
        switch self.type {
        case .train(let train):
            return Date(bartTime: train.stopTime.arrivalTime)
        case .tripPlan(let plan):
            return plan.connections.first?.startTime ?? .now
        }
    }
    public var type: ArrivalType
    
}
public enum ArrivalType {

    case train(Train)
    case tripPlan(TripPlan)
}

public struct Train: Identifiable {
    public let id: String 
    public let stopTime: StopTime
    public let trip: Trip
    public let route: Route
    public let direction: String
    
    public init(stopTime: StopTime, trip: Trip, route: Route) {
        self.stopTime = stopTime
        self.trip = trip
        self.route = route
        self.id = stopTime.id
        if (!stopTime.stopHeadsign.isEmpty && false) {
            self.direction = stopTime.stopHeadsign + "STOP"
        } else {
            var direction =  String((trip.tripHeadsign ?? "").split(separator: " / ").last ?? "")
            if (direction == "San Francisco International Airport") {
                direction = "SFO Airport"
            }
            self.direction = direction
        }
    }
}

public struct TripPlan: Identifiable {
    public var id: String {
        return connections.first?.startStopTimeId ?? ""
    }
    public let connections: [Connection]
    public let steps: [TripPlanItem]
    public var time: TimeInterval {
        return  self.connections.last!.endTime.timeIntervalSince(self.connections.first!.startTime)
    }
    init(connections: [Connection]) {
        print("TRIP PLAN INIT", connections.count)
        self.connections = connections
        var workingSteps: [TripPlanItem] = []
        var workingConnections: [Connection] = []
        for connection in connections {
          print("TRIP PLAN checking ", connection)
            guard let lastTripId =  workingConnections.last?.tripId else {
                workingConnections.append(connection)
                if connection.endStation == connections.last?.endStation ?? "" {
                    var intermediateStopTimes: [String] = []
                print("TRIP PLAN", workingConnections.map({i in return i.startStation}), "guard")
                        intermediateStopTimes = workingConnections.dropLast(1).dropFirst(1).map({connection in
                            return connection.startStopTimeId
                        })
                    workingSteps.append(TripPlanItem.ride(TripPlanRide(startStopTime: connection.startStopTimeId, intermediaryStopTimes: intermediateStopTimes, endStopTime: connection.endStopTimeId, trip: connection.tripId)))
                    print("TRIP PLAN appended last step no previous tripid (one ride)")
                  
                }
                continue
            }
          if lastTripId == connection.tripId {
                workingConnections.append(connection)
                if connection.endStation == connections.last?.endStation ?? "" {
                    var intermediateStopTimes: [String] = []
                
                        intermediateStopTimes = workingConnections.dropFirst(1).map({connection in
                            return connection.startStopTimeId
                        })
                    print("TRIP PLAN", workingConnections.map({i in return i.startStation}), "==")
                    workingSteps.append(TripPlanItem.ride(TripPlanRide(startStopTime: workingConnections.first!.startStopTimeId, intermediaryStopTimes: intermediateStopTimes, endStopTime: workingConnections.last!.endStopTimeId, trip: lastTripId)))
                    print("TRIP PLAN appended last step same tripid")
                   
                }
               
            } else {
                if connection.endStation == connections.last?.endStation ?? "" {
                    var intermediateStopTimes: [String] = []
                  
                        intermediateStopTimes = workingConnections.dropFirst(1).map({connection in
                            return connection.startStopTimeId
                        })
                    print("TRIP PLAN", workingConnections.map({i in return i.startStation}), "!== ==")
                    
                    workingSteps.append(TripPlanItem.ride(TripPlanRide(startStopTime: workingConnections.first!.startStopTimeId, intermediaryStopTimes: intermediateStopTimes, endStopTime: workingConnections.last!.endStopTimeId, trip: lastTripId)))
                    workingSteps.append(.tranfer(.init(station: connection.startStation, duration: connection.startTime.timeIntervalSince(workingConnections.last!.endTime))))
                    workingSteps.append(TripPlanItem.ride(TripPlanRide(startStopTime: connection.startStopTimeId, intermediaryStopTimes: [], endStopTime: connection.endStopTimeId, trip: connection.tripId)))
                 
                    print("TRIP PLAN appended last step different trip id")
                } else {
                    var intermediateStopTimes: [String] = []
                  
                        intermediateStopTimes = workingConnections.dropFirst(1).map({connection in
                            return connection.startStopTimeId
                        })
                    
                    workingSteps.append(TripPlanItem.ride(TripPlanRide(startStopTime: workingConnections.first!.startStopTimeId, intermediaryStopTimes: intermediateStopTimes, endStopTime: workingConnections.last!.endStopTimeId, trip: lastTripId)))
                  print("TRIP PLAN appended step")
                    workingSteps.append(.tranfer(.init(station: connection.startStation, duration: connection.startTime.timeIntervalSince(workingConnections.last!.endTime))))
                    workingConnections = [connection]
                }
            }
        }
        self.steps = workingSteps
        print("TRIP PLAN INIT DONE", connections.count, self.steps.count)
    }
    
}



public enum TripPlanItem: Identifiable {
    public var id: String {
        switch self {
        case .ride(let ride):
            return ride.startStopTime + ride.endStopTime
        case .tranfer(let description):
            return description.station + description.duration.description
        }
    }
    case ride(TripPlanRide)
    case tranfer(Transfer)
}

public struct TripPlanRide {
    public var startStopTime: String
    public var intermediaryStopTimes: [String]
    public var endStopTime: String
    public var trip: String
  
}
public struct Transfer {
    public var station: String
    public var duration: TimeInterval
}
