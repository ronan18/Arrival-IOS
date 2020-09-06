//
//  TimeOptions.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

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

struct TimeOptions: View {
    private enum timeType {
        case leave
        case arrive
    }
    @State private var timePickerType: timeType = .leave
    @State var timePickerPopoverPresented = true
    @State private var selection: Date = Date()
    var options: TimeOptionsInput
    var close: (() -> ())
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack() {
                    Text("Time Options")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: close) {
                        Text("close")
                    }
                    
                }
                
                
                VStack(alignment: .leading) {
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Leave:")
                            .font(.subheadline)
                        HStack {
                            TimeOption(value: self.options.leave[0].value, selected: self.options.leave[0].selected, unit: self.options.leave[0].unit, type:self.options.leave[0].type, action: self.options.leave[0].action )
                            Spacer()
                            TimeOption(value: self.options.leave[1].value, selected: self.options.leave[1].selected, unit: self.options.leave[1].unit, type:self.options.leave[1].type, action: self.options.leave[1].action )
                            Spacer()
                            TimeOption(value: self.options.leaveChoose.value, selected: self.options.leaveChoose.selected, unit: self.options.leaveChoose.unit, type: TimeOptionType.choose, action: {
                                self.timePickerType = .leave
                                withAnimation {
                                    self.timePickerPopoverPresented = true
                                }
                                
                            } )
                        }.padding(.vertical)
                    }.padding(.vertical)
                    if (self.options.arrive != nil) {
                        VStack(alignment: .leading) {
                            Text("Arrive:")
                                .font(.subheadline)
                            HStack {
                                TimeOption(value: self.options.arrive![0].value, selected: self.options.arrive![0].selected, unit: self.options.arrive![0].unit, type:self.options.arrive![0].type, action: self.options.arrive![0].action )
                                Spacer()
                                TimeOption(value: self.options.arrive![1].value, selected: self.options.arrive![1].selected, unit: self.options.arrive![1].unit, type:self.options.arrive![1].type, action: self.options.arrive![1].action )
                                Spacer()
                                TimeOption(value: self.options.arrive![2].value, selected: self.options.arrive![2].selected, unit: self.options.arrive![2].unit, type:self.options.arrive![2].type, action: self.options.arrive![1].action )
                            }.padding(.vertical)
                            HStack {
                                TimeOption(value: self.options.arrive![3].value, selected: self.options.arrive![3].selected, unit: self.options.arrive![3].unit, type:self.options.arrive![3].type, action: self.options.arrive![3].action )
                                Spacer()
                                TimeOption(value: self.options.arrive![4].value, selected: self.options.arrive![4].selected, unit: self.options.arrive![4].unit, type:self.options.arrive![4].type, action: self.options.arrive![4].action )
                                Spacer()
                                TimeOption(value: self.options.arriveChoose!.value, selected: self.options.arriveChoose!.selected, unit: self.options.arriveChoose!.unit, type: TimeOptionType.choose, action: {
                                    self.timePickerType = .arrive
                                    withAnimation {
                                        self.timePickerPopoverPresented = true
                                    }
                                } )
                            }.padding(.vertical)
                        }
                    }
                }
                Spacer()
            }.padding()
            if (self.timePickerPopoverPresented) {
                VStack {
                    
                    Spacer()
                    HStack {
                        VStack {
                            HStack {
                                if (self.timePickerType == .leave) {
                                    Text("Choose a departure time")
                                        .font(.headline)
                                } else {
                                    Text("Choose an arrival time")
                                        .font(.headline)
                                }
                                
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        self.timePickerPopoverPresented = false
                                    }}) {
                                        Text("close")
                                }
                                
                            }.padding([.horizontal, .top])
                            Divider().padding([.horizontal])
                            DatePicker(selection: $selection, in: Date(timeIntervalSinceNow: 300)..., displayedComponents: .hourAndMinute) {
                                Text("")
                            }
                            VStack {
                                StyledButton(action: {
                                    if (self.timePickerType == .leave) {
                                        self.options.leaveChoose.action()
                                    } else {
                                        self.options.arriveChoose!.action()
                                    }
                                }, text: "Choose")
                            }.padding()
                            
                        }
                    }.frame(maxHeight: 370).background(Color.white).cornerRadius(10).padding(20)
                    Spacer()
                }.background(Color("modalBG")).edgesIgnoringSafeArea(.all).onTapGesture {
                    withAnimation {
                        self.timePickerPopoverPresented = false
                    }
                }
                
            }
        }
    }
}

struct TimeOptions_Previews: PreviewProvider {
    static var previews: some View {
        
        TimeOptions(options: sampleTimeOptions, close: {print("close")})
        
        
    }
}
