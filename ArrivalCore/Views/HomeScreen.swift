//
//  HomeScreen.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
struct HomeScreen: View {
    @State var stationModalPresented = true
    @State var stationModalType: StationType = .from
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HomeScreenHeader(geometry: geometry)
                StationChooserBar(leftAction: {self.stationModalType = .from; self.stationModalPresented = true}, centerAction: {print("center")}, rightAction: {self.stationModalType = .to; self.stationModalPresented = true})
                AlertView(text: "California is under a mandatory shelter at home order during the Covid-19 pandemic. All non-essential travel should be avoided. BART is operating under a modified schedule and closes at 9pm. Weekday trains run every 30 minutes. Face coverings are required.", link: URL(string:"https://google.com"))
                Spacer()
                List {
                    TrainCard(direction: "Dublin/Pleasonton", color: TrainColor.blue, cars: 5, departs: Date(timeIntervalSinceNow: 600))
                    TrainCard(direction: "Antioch", color: TrainColor.yellow, departs: Date(timeIntervalSinceNow: 500),  arrives: Date(timeIntervalSinceNow: 1800))
                }
            }.sheet(isPresented: self.$stationModalPresented) {
                StationChooser(stations: mockData.stations, type: self.stationModalType, close: {self.stationModalPresented = false}, choose: {station in print("choose",StationTypeName(self.stationModalType), station.name) ; self.stationModalPresented = false})
            }
            
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


