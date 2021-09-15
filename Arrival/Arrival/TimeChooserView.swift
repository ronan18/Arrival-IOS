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
            ZStack {
               
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
                                .datePickerStyle(GraphicalDatePickerStyle()).frame(maxHeight: 400).onAppear {
                                    self.customTime = self.appState.timeConfig.time
                                }
                                
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
                if (self.appState.toStation == nil) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                       
                    }
                    
                    Spacer()
                }.background(.regularMaterial).opacity(0.9)
                VStack {
                    Spacer()
                   
                    Text("No Destination Station Specified").foregroundColor(Color("TextColor")).font(.title).bold().multilineTextAlignment(.center).padding(.bottom, 5)
                    Text("Please choose a destination station before choosing a time").multilineTextAlignment(.center).foregroundColor(Color("TextColor"))
                    HStack {
                        Spacer()
                        Button(action: {
                            self.appState.timeChooser = false
                            self.appState.toStationChooser = true
                        }) {
                            Image(systemName: "list.dash")
                            Text("Choose destination station")
                        }.buttonStyle(.borderedProminent).controlSize(.small).buttonBorderShape(.capsule)
                        
                        Spacer()
                    }.padding()
                    Spacer()
                }
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
