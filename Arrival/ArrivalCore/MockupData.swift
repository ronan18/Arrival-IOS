//
//  MockupData.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/27/21.
//

import Foundation

public class MockUpData {
    public init() {}
    public var station: Station = Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil)
    public var train: Train = Train(departureStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), destinationStation: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), etd: Date(timeIntervalSinceNow: 5000), platform: 1, direction: .north, delay: 0, bikeFlag: 1, color: TrainColor.red, cars: 10)
    public var trip: Trip = Trip(id: "test", origin: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), destination: Station(id: "ROCK", name: "Rockridge", abbr: "ROCK", lat: nil, long: nil), originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 600), tripTime: 7000, legs: [TripLeg(order: 2, origin: "ROCK", destination: "ROCK", originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 500), route: Route(routeNumber: 2, name: "", abbr: "", origin: "", destination: "", direction: .north, color: .red, stationCount: 20, stations: ["test", "test", "test"]), trainHeadSTN: "String")])
    public var helpScreen: helpScreenData = helpScreenData(name: "What's New", subtitle: "Discover new Arrival Features", image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80", content: [helpScreenContentRow(type: .image, content: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80"), helpScreenContentRow(type: .text, content: "In arrival new version we have addeda  lot of new stuff for your usability and stuff. including this brand new help screen *wow*"),helpScreenContentRow(type: .spacer, content: ""), helpScreenContentRow(type: .text, content: "There are five new features in this thing"), helpScreenContentRow(type: .devider, content: ""),helpScreenContentRow(type: .heading, content: "Heading"),helpScreenContentRow(type: .spacer, content: ""), helpScreenContentRow(type: .text, content: "Post heading text"),helpScreenContentRow(type: .image, content: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80")])
}
