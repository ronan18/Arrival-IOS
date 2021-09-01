//
//  Maps.service.swift
//  Maps.service
//
//  Created by Ronan Furuta on 8/28/21.
//

import Foundation
import MapKit
import CoreLocation

public class MapService {
    public var location: CLLocation? = nil
    public init () {
        
    }
    public func timeTo(_ station: Station) async -> (Date?, String) {
        print("MAPS SERVICE request smart time to \(station.name)")
        guard station.firstFive else {
            return (nil, "nil")
        }
        guard let stationLat = station.lat else {
            return (nil, "nil")
        }
        guard let stationLong = station.long else {
            return (nil, "nil")
        }
        var currentLocation: MKMapItem
        if let location = self.location {
            currentLocation =  MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
            //print("using arrival location info")
        } else {
            currentLocation = MKMapItem.forCurrentLocation()
         //   print("using system location info")
        }
        let stationLocation = MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: stationLat, longitude: stationLong)))
        let distance = await self.distanceTo(station) ?? 100
        if (distance <= 1.2) {
            return await (self.walkingTimeTo(station), "walking")
        } else {
            return await (self.drivingTimeTo(station), "driving")
        }
    }
    public func drivingTimeTo(_ station: Station) async -> Date? {
        print("MAPS SERVICE request driving time to \(station.name)")
        guard let stationLat = station.lat else {
            return nil
        }
        guard let stationLong = station.long else {
            return nil
        }
        //print("MAPS SERVICE \(station.name) has location data")
        var currentLocation: MKMapItem
        if let location = self.location {
            currentLocation =  MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
            //print("using arrival location info")
        } else {
            currentLocation = MKMapItem.forCurrentLocation()
         //   print("using system location info")
        }
        let stationLocation = MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: stationLat, longitude: stationLong)))
       
        let request = MKDirections.Request()
        request.source = currentLocation
        request.destination = stationLocation
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        do {
           let eta = try await directions.calculateETA()
            let etaDate = eta.expectedArrivalDate
            return etaDate
        } catch {
           
            return nil
        }
        // TODO: throttle this and turn into a recursive que
        //return Date()
    }
    public func walkingTimeTo(_ station: Station) async -> Date? {
        print("MAPS SERVICE request walking time to \(station.name)")
        guard let stationLat = station.lat else {
            return nil
        }
        guard let stationLong = station.long else {
            return nil
        }
        //print("MAPS SERVICE \(station.name) has location data")
        var currentLocation: MKMapItem
        if let location = self.location {
            currentLocation =  MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
            //print("using arrival location info")
        } else {
            currentLocation = MKMapItem.forCurrentLocation()
         //   print("using system location info")
        }
        let stationLocation = MKMapItem.init(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: stationLat, longitude: stationLong)))
       
        let request = MKDirections.Request()
        request.source = currentLocation
        request.destination = stationLocation
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        let directions = MKDirections(request: request)
        do {
           let eta = try await directions.calculateETA()
            let etaDate = eta.expectedArrivalDate
            return etaDate
        } catch {
           
            return nil
        }
        // TODO: throttle this and turn into a recursive que
        //return Date()
    }
    public func distanceTo(_ station: Station) async -> Double? {
        print("MAPS SERVICE request distance to \(station.name)")
        guard let stationLat = station.lat else {
            return nil
        }
        guard let stationLong = station.long else {
            return nil
        }
        guard let currentLocation = self.location else {
            print("no location data")
            return nil
        }
        //print("MAPS SERVICE \(station.name) has location data")
   
        let stationLocation = CLLocation(latitude: stationLat, longitude: stationLong)
        let distance = (stationLocation.distance(from: currentLocation) * 0.000621371192)
        return round(10*distance)/10
    }
}
