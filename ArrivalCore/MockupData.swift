//
//  MockupData.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation

class Mockdata {
    let stations: [Station] = [Station(id: "ROCK", name: "Rockridge", abbr: "ROCK"), Station(id: "BALB", name: "Balboa", abbr: "BALB"), Station(id: "WARM", name: "Warm Springs/South Freemont", abbr: "WARM")]
}
let leaveSampleOptions = [TimeOptionInput(value: "now", selected: true, action: {print("now")}, type:TimeOptionType.preSet), TimeOptionInput(value: "15", unit: "min", selected: false, action: {print("now")}, type:TimeOptionType.preSet), TimeOptionInput(value: "choose", selected: false, action: {print("choose")}, type:TimeOptionType.choose)]

let arriveSampleOptions = [TimeOptionInput(value: "9:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "10:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "12:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "4:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "6:00", unit: "pm", selected: false, action: {print("now")}, type:TimeOptionType.preSet),  TimeOptionInput(value: "9:00", unit: "am", selected: false, action: {print("now")}, type:TimeOptionType.choose)]

let sampleTimeOptions = TimeOptionsInput(leave: leaveSampleOptions, arrive: arriveSampleOptions)
