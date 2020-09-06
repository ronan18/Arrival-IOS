//
//  FromStationChooser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
let mockData = Mockdata()
enum StationType {
    case from
    case to
}

func StationTypeName (_ type: StationType) -> String {
    switch type {
    case .from:
        return "Departure"
    case .to:
        return "Destination"
    }
}

struct StationChooser: View {
    @State var showModalState: Bool = true
    @State var search: String = ""
    let stations: [Station]
    let type: StationType
    @State var filteredStations: [Station] = []
    init(showModal: Binding<Bool>, stations: [Station], type: StationType) {
   
        self.stations = stations
        self.type = type
        self.filteredStations = stations
        self.showModalState = showModal.wrappedValue
        
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack() {
                Text("\(StationTypeName(type)) Station")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    self.showModalState = false}) {
                    Text("close")
                }
                }.padding([.horizontal, .top])
              
            SearchBar(text: $search).padding(.horizontal, 1)
            VStack(alignment: .leading) {
            Text("suggested")
                .font(.caption)
                .multilineTextAlignment(.leading)
                Divider()
                List(stations) {station in
                    StationCard(station: station).padding(.horizontal, -15).listRowInsets(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    }.listRowInsets(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).padding(0)
            }.padding(.horizontal)
            Spacer()
        }
    }
}

struct FromStationChooser_Previews: PreviewProvider {
    static var previews: some View {
        StationChooser(showModal: .constant(true), stations: mockData.stations, type: .from)
    }
}
