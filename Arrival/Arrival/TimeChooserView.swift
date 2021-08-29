//
//  TimeChooserView.swift
//  TimeChooserView
//
//  Created by Ronan Furuta on 8/29/21.
//

import SwiftUI
import ArrivalCore
import ArrivalUI
struct TimeChooserView: View {
    @ObservedObject var appState: AppState
    @State var leaveArrive = 1
    @State var customTime: Date = Date()
    func choose(_ time: TripTime) {
        self.appState.setTripTime(time)
        self.appState.timeChooser = false
        
    }
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        Picker(selection: self.$leaveArrive, label: Text("Leave or Arrive")) {
                            Text("Leave").tag(1)
                            Text("Arrive").tag(2)
                        }.pickerStyle(SegmentedPickerStyle()).padding(.bottom)
                        
                            HStack {
                                Text("Quick options")
                                    .font(.caption)
                                    .foregroundColor(Color("TextColor"))
                                Spacer()
                            }
                            Divider()
                            
                            HStack {
                                TripTimeOption(TripTime(type: .now), choose: {time in
                                    self.choose(time)
                                }, size: geo.size.width / 5.2)
                                Spacer()
                                TripTimeOption(TripTime(type: .leave, time: Date(timeIntervalSinceNow: 65*10)), choose: {time in
                                    self.choose(time)}, size: geo.size.width / 5.2)
                                Spacer()
                                TripTimeOption(TripTime(type: .leave, time: Date(timeIntervalSinceNow: 65*20)), choose: {time in
                                    self.choose(time)}, size: geo.size.width / 5.2)
                            }.padding(.bottom)
                        
                       
                            HStack {
                                Text("Or specify your own time")
                                    .font(.caption)
                                    .foregroundColor(Color("TextColor"))
                                Spacer()
                            }.padding(.top)
                            Divider()
                            DatePicker("Specify a custom time", selection: $customTime)
                                .datePickerStyle(GraphicalDatePickerStyle()).frame(maxHeight: 400)
                            
                            LargeButton("Choose", action: {
                                if (self.leaveArrive == 1) {
                                    self.choose(TripTime(type: .leave, time: self.customTime))
                                } else {
                                    self.choose(TripTime(type: .arrive, time: self.customTime))
                                }
                                
                            })
                        
                        
                        Spacer()
                    }.padding().navigationBarTitle("Choose Trip Time").navigationBarItems(trailing:Button(action: {
                        self.appState.timeChooser = false
                    }) {
                        Text("Done")
                            .foregroundColor(Color("TextColor"))
                    }).navigationBarTitleDisplayMode(.large)
                }
            }
        }
    }
}

struct TimeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TimeChooserView(appState: AppState())
    }
}
