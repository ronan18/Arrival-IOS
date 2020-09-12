//
//  tripTime.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

enum TimeMode {
    case leave
    case arrive
    case now
}

struct TripTimeModel {
    var timeMode: TimeMode
    var time: Date
}

class TimeOptionInput: Identifiable {
    let id = UUID()
    var value: String? = nil
    var unit: String? = nil
    let selected: Bool
    var action: (()->())
    var type: TimeOptionType
    init(value: String? = nil, unit: String? = nil, selected: Bool, action: @escaping (() -> ()), type: TimeOptionType) {
        self.value = value
        self.unit = unit
        self.selected = selected
        self.action = action
        self.type = type
    }
    
}
class ChooseOption: Identifiable {
    let id = UUID()
    var value: String? = nil
    var unit: String? = nil
    let selected: Bool
    var action: (()->())
    init(value: String? = nil, unit: String? = nil, selected: Bool, action: @escaping (() -> ())) {
        self.value = value
        self.unit = unit
        self.selected = selected
        self.action = action
    }
    
}


class TimeOptionsInput {
    let leave: [TimeOptionInput]
    let leaveChoose: ChooseOption
    let arrive: [TimeOptionInput]?
    let arriveChoose: ChooseOption?
    init(leave: [TimeOptionInput], leaveChoose: ChooseOption, arrive: [TimeOptionInput]?, arriveChoose: ChooseOption?) {
        self.leave = leave
        self.arrive = arrive
        self.arriveChoose = arriveChoose
        self.leaveChoose = leaveChoose
    }
}
enum TimeOptionType {
    case preSet
    case choose
}
