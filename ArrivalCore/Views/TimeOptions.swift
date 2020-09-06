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


class TimeOptionsInput {
    let leave: [TimeOptionInput]
    let arrive: [TimeOptionInput]?
    init(leave: [TimeOptionInput], arrive: [TimeOptionInput]?) {
        self.leave = leave
        self.arrive = arrive
    }
}

struct TimeOptions: View {
    
    var options: TimeOptionsInput
    var close: (() -> ())
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack() {
                Text("Time Options")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: close) {
                    Text("close")
                }
                
            }.padding([.horizontal, .top])
            
            
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
                        TimeOption(value: self.options.leave[2].value, selected: self.options.leave[2].selected, unit: self.options.leave[2].unit, type:self.options.leave[2].type, action: self.options.leave[1].action )
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
                            TimeOption(value: self.options.arrive![5].value, selected: self.options.arrive![5].selected, unit: self.options.arrive![5].unit, type:self.options.arrive![5].type, action: self.options.arrive![5].action )
                        }.padding(.vertical)
                    }.padding(.vertical)
                }
            }.padding()
            Spacer()
        }
    }
}

struct TimeOptions_Previews: PreviewProvider {
    static var previews: some View {
        
        TimeOptions(options: sampleTimeOptions, close: {print("close")})
        
        
    }
}
