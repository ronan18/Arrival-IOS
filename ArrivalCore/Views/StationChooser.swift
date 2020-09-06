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
func runFilter(station: Station, search: String) -> Bool {
    if (search.count >= 1) {
        return station.abbr.lowercased().contains(search.lowercased())
    } else {return true}
}

struct StationChooser: View {
    var close: (() -> ())
    var choose:  ((Station) -> ())
    @State var search: String = ""
    let stations: [Station]
    let type: StationType
    @State var filteredStations: [Station] = []
    init(stations: [Station], type: StationType, close: @escaping (() -> ()), choose: @escaping ((Station) -> ())) {
        self.close = close
        self.stations = stations
        self.type = type
        self.choose = choose
        self.filteredStations = stations
      
        
        
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack() {
                Text("\(StationTypeName(type)) Station")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: close) {
                    Text("close")
                }
                }.padding([.horizontal, .top])
              
            SearchBar(text: $search).padding(.horizontal, 1)
            VStack(alignment: .leading) {
            Text("suggested")
                .font(.caption)
                .multilineTextAlignment(.leading)
                Divider()
                List(stations.filter {runFilter(station: $0, search: self.search)}) {station in
                    Button(action: {self.choose(station)}) {
                    StationCard(station: station).padding(.horizontal, -15).listRowInsets(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    }
                }.listRowInsets(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)).padding(0)
            }.padding(.horizontal)
            Spacer()
        }
    }
}

struct FromStationChooser_Previews: PreviewProvider {
    static var previews: some View {
        StationChooser(stations: mockData.stations, type: .from, close: {print("close")}, choose: {station in print("choose",station.abbr)})
    }
}
