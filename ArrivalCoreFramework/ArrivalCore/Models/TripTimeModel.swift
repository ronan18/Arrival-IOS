//
//  tripTime.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

public enum TimeMode {
    case leave
    case arrive
    case now
}

public struct TripTimeModel: Identifiable {
    public let id = UUID()
    public var timeMode: TimeMode
    public var time: Date
    public init (timeMode: TimeMode, time: Date) {
        self.timeMode = timeMode
        self.time = time
    }
}

public struct TimeSuggestion {
    let leave: TripTimeModel // 1 option
    let arrive: [TripTimeModel] // 5 options
}

public class TimeOptionInput: Identifiable {
    public let id = UUID()
    public var value: String? = nil
    public var unit: String? = nil
    public let selected: Bool
    public var action: (()->())
    public var type: TimeOptionType
    public init(value: String? = nil, unit: String? = nil, selected: Bool, action: @escaping (() -> ()), type: TimeOptionType) {
        self.value = value
        self.unit = unit
        self.selected = selected
        self.action = action
        self.type = type
    }
    
}
public class ChooseOption: Identifiable {
    public let id = UUID()
    public var value: String
    public var time: Date
    public var unit: String
    public init(time: Date, value: String, unit: String, action: @escaping (() -> ())) {
        self.value = value
        self.unit = unit
        self.time = time
     
       
    }
    
}


public class TimeOptionsInput {
    public let leave: [TimeOptionInput]
    public let leaveChoose: ChooseOption
    public let arrive: [TimeOptionInput]?
    public let arriveChoose: ChooseOption?
    public init(leave: [TimeOptionInput], leaveChoose: ChooseOption, arrive: [TimeOptionInput]?, arriveChoose: ChooseOption?) {
        self.leave = leave
        self.arrive = arrive
        self.arriveChoose = arriveChoose
        self.leaveChoose = leaveChoose
    }
}
public enum TimeOptionType {
    case preSet
    case choose
}
