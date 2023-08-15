//
//  APIManager.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/10/23.
//

import Foundation
import ArrivalGTFS

public enum ApiError: Error {
    case not200
    case decodeError
}

public class ArrivalAPIManager {
    
#if targetEnvironment(simulator)
    //private let apiURL = URL(string: "https://api2.arrival.city/v2/")!
    private let apiURL = URL(string: "http://127.0.0.1:8080/v2/")!
#else
    private let apiURL = URL(string: "https://api2.arrival.city/v2/")!
#endif
    public func stationsDB() async  throws -> StationsDB {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "stations"))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(StationsResponse.self, from: data)
            return StationsDB(from: result.stations)
        } catch {
            print(error)
            throw error
        }
    }
    public func trains(from station: Stop, at: Date) async throws -> TrainsResponse {
        print("fetching arrivals", station.stopId, apiURL.appending(path: "trains").appending(path: station.stopId).appending(path: String(at.timeIntervalSince1970)).absoluteString)
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "trains").appending(path: station.stopId).appending(path: String(at.timeIntervalSince1970)))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
            print(data, apiURL.appending(path: "arrivals").appending(path: station.stopId).appending(path: at.ISO8601Format()).absoluteString)
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(TrainsResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    public func tripPlan(from station: Stop, to: Stop, at: Date) async throws -> TripPlansResponse {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "plan").appending(path: station.stopId).appending(path: to.stopId).appending(path: String(at.timeIntervalSince1970)))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
            print(data)
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(TripPlansResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    public func trip(tripId:String ) async throws -> TripResponse {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "trip").appending(path: tripId))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
           
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(TripResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    public func stopTimes(for tripId: String) async throws -> StopTimesResponse {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "stoptimes").appending(path: "bytrip").appending(path: tripId))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
           
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(StopTimesResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    
    public func stopTime(by id: String) async throws -> StopTimeResponse {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "stoptime").appending(path: id))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
           
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(StopTimeResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    public func allRoutes() async throws -> RoutesDBResponse {
        let (data, response) = try await URLSession.shared.data(from: apiURL.appending(path: "routes").appending(path: "db"))
        guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
           
            throw ApiError.not200
            }
        do {
            let result = try JSONDecoder().decode(RoutesDBResponse.self, from: data)
            return result
        } catch {
            print(error)
            throw error
        }
    }
    
}
public struct StationsResponse:Codable {
    let hash: Int
    let stations: [Stop]
    let date: String
}
public struct StopTimesResponse:Codable {
    let hash: Int
    let stopTimes: [StopTime]
    let date: String
}
public struct StopTimeResponse:Codable {
 
    let stopTime: StopTime
 
}
public struct RoutesResponse:Codable {
    let hash: Int
    let routes: [Route]
    let date: String
}
public struct RoutesDBResponse:Codable {
    let hash: Int
    let db: RoutesDB
    let date: String
}
public struct TrainsResponse:Codable {
    let stopTimes: [StopTime]
    let routes: [String: Route]
    let trips: [String: Trip]
    let time: String
}
public struct TripPlansResponse:Codable {
    let connections: [[Connection]]
    let stopTimes: [String: StopTime]
   
    let trips: [String: Trip]
    let time: Date
}


public struct TripResponse:Codable {
    
    let trip: Trip
    
}
