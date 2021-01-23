//
//  MockupData.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

public class MockData {
    public init() {
        
    }
    public let stations: [Station] = [Station(id: "ROCK", name: "Rockridge", abbr: "ROCK"), Station(id: "BALB", name: "Balboa", abbr: "BALB"), Station(id: "WARM", name: "Warm Springs/South Freemont", abbr: "WARM")]
    public let trips: [Trip] = [Trip(id: "test", origin: Station(id: "test", name: "Rockridge", abbr: "ROCK"), destination: Station(id: "BALB", name: "Balboa Park", abbr: "BALB"), originTime: Date(), destinationTime: Date(timeIntervalSinceNow: (60*54)), tripTime: TimeInterval(60*54), legs: [TripLeg(order: 1, origin: "ROCK", destination: "BALB", originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 60*54), route: Route(routeNumber: 1, name: "SF.BALB", abbr: "ABKB", origin: "Rockridge", destination: "SF", direction: .north, color: .black, stationCount: 20, stations: ["rock"]), trainHeadSTN: "SF Airport"), TripLeg(order: 1, origin: "ROCK", destination: "BALB", originTime: Date(), destinationTime: Date(timeIntervalSinceNow: 60*54), route: Route(routeNumber: 1, name: "SF.BALB", abbr: "ABKB", origin: "Rockridge", destination: "SF", direction: .north, color: .black, stationCount: 20, stations: ["rock"]), trainHeadSTN: "SF Airport", finalLeg: true)])]
    public let stationStorage: StationStorage = StationStorage(stations: [Station(id: "ROCK", name: "Rockridge", abbr: "ROCK"), Station(id: "BALB", name: "Balboa", abbr: "BALB"), Station(id: "WARM", name: "Warm Springs/South Freemont", abbr: "WARM")], byAbbr: ["ROCK" : Station(id: "ROCK", name: "Rockridge", abbr: "ROCK"), "BALB" : Station(id: "BALB", name: "Balboa", abbr: "BALB"), "WARM" : Station(id: "WARM", name: "Warm Springs/South Freemont", abbr: "WARM")], version: 1.0)
    public let trains: [Train] = []
}
public let leaveSampleOptions = [TimeOptionInput(value: "now", selected: true, action: {print("now")}, type:TimeOptionType.preSet), TimeOptionInput(value: "15", unit: "min", selected: false, action: {print("now")}, type:TimeOptionType.preSet), TimeOptionInput(value: "choose", selected: false, action: {print("choose")}, type:TimeOptionType.choose)]

public let arriveSampleOptions = [TimeOptionInput(value: "9:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "10:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "12:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "4:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "6:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "9:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.choose)]

//public let sampleLeaveChoose = ChooseOption(selected: false, action: {print("choose")})
//public let sampleArriveChoose = ChooseOption(value: "9:00", unit: "am", selected: false, action: {print("choose")})
public let sampleTimeOptions = TimeSuggestion(leave: TripTimeModel(timeMode: .leave, time: Date(timeIntervalSinceNow: (15*60))), arrive: [TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (1*60*60))), TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (4*60*60))), TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (6*60*60))),TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (10*60*60))),TripTimeModel(timeMode: .arrive, time: Date(timeIntervalSinceNow: (24*60*60)))])
