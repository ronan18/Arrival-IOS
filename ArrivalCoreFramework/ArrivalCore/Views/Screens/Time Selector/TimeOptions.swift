//
//  TimeOptions.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI


public struct TimeOptions: View {
    private enum timeType {
        case leave
        case arrive
    }
    @State private var timePickerType: timeType = .leave
    @State var timePickerPopoverPresented = false
    @State private var selection: Date = Date()
    var leaveTimes = false
    var leaveTimesRow1: [TripTimeModel] = []
    var leaveTimesRow2: [TripTimeModel] = []
    var options: TimeSuggestion
    var close: (() -> ())
    var choose: (TripTimeModel) -> ()
    func chooseTime(_ time: TripTimeModel) {
        self.choose(time)
    }
    public init(options: TimeSuggestion, choose: @escaping (TripTimeModel) -> (),close: @escaping (() -> ()) ) {
        self.options = options
        self.close = close
        print("leave times count",self.options.arrive.count)
        self.choose = choose
        if (self.options.arrive.count == 5) {
          
            self.leaveTimes = true
            leaveTimesRow1 = Array(options.arrive.prefix(3))
            leaveTimesRow2 = Array(options.arrive.suffix(2))
                  
            
        }
    }
    public var body: some View {
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
                            Spacer()
                            TimeOption(value: "now", selected: true, action: {chooseTime(TripTimeModel(timeMode: .now, time: Date()))} )
                            Spacer()
                            TimeOption(value: displayTime(self.options.leave.time).time, selected: false, unit: displayTime(self.options.leave.time).a, type: .preSet, action: {
                                self.chooseTime(self.options.leave)
                                
                            } )
                            Spacer()
                            TimeOption(value: nil, selected: false, unit: "", type: TimeOptionType.choose, action: {
                                self.timePickerType = .leave
                                withAnimation {
                                    self.timePickerPopoverPresented = true
                                }
                                
                            } )
                            Spacer()
                        }.padding(.vertical)
                    }.padding(.vertical)
                    if (self.leaveTimes) {
                        
                        VStack(alignment: .leading) {
                            Text("Arrive:")
                                .font(.subheadline)
                            HStack {
                                ForEach(self.leaveTimesRow1) { option in
                                    Spacer()
                                    TimeOption(value: displayTime(option.time).time, selected: false, unit: displayTime(option.time).a, type: .preSet, action: {chooseTime(option)} )
                                    Spacer()
                                }
                            }.padding(.top).padding(.bottom, 10)
                            
                            HStack {
                                ForEach(self.leaveTimesRow2) { option in
                                    Spacer()
                                    TimeOption(value: displayTime(option.time).time, selected: false, unit: displayTime(option.time).a, type: .preSet, action: {chooseTime(option)} )
                                    Spacer()
                                }
                                Spacer()
                                TimeOption(value: nil, selected: false, unit: "", type: TimeOptionType.choose, action: {
                                    self.timePickerType = .arrive
                                    withAnimation {
                                        self.timePickerPopoverPresented = true
                                    }
                                } )
                                Spacer()
                            }.padding(.bottom, 5)
                        }
                        
                    }
                }
                Spacer()
            }.padding()
            if (self.timePickerPopoverPresented) {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("")
                        }
                      
                      Spacer()
                    }.background(Color("modalBG")).edgesIgnoringSafeArea(.all).onTapGesture {
                        withAnimation {
                            self.timePickerPopoverPresented = false
                        }
                    }
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
                            Spacer()
                            HStack {
                                Spacer()
                                DatePicker(selection: $selection,  displayedComponents: .hourAndMinute) {
                                    EmptyView()
                                }.labelsHidden()
                                Spacer()
                            }.datePickerStyle(WheelDatePickerStyle())
                            Spacer()
                            VStack {
                                StyledButton(action: {
                                    if (self.timePickerType == .leave) {
                                        let result = TripTimeModel(timeMode: .leave, time: self.selection)
                                        self.timePickerPopoverPresented = false
                                        self.chooseTime(result)
                                      //  self.options.leaveChoose.action()
                                    } else {
                                        let result = TripTimeModel(timeMode: .arrive, time: self.selection)
                                        self.timePickerPopoverPresented = false
                                        self.chooseTime(result)
//self.options.arriveChoose!.action()
                                    }
                                }, text: "Choose")
                            }.padding()
                            
                        }
                    }.frame(maxHeight: 370).background(Color("cardBackground")).cornerRadius(10).padding(20)
                    Spacer()
                    }
                    
                }
                
            }
        }
    }
}

struct TimeOptions_Previews: PreviewProvider {
    static var previews: some View {
        
        TimeOptions(options: sampleTimeOptions,choose: {i in }, close: {print("close")})
        
        
    }
}
