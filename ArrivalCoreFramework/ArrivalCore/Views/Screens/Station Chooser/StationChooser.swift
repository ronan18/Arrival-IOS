//
//  FromStationChooser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
let mockData = MockData()
public enum StationType {
    case from
    case to
}

public func StationTypeName (_ type: StationType) -> String {
    switch type {
    case .from:
        return "Departure"
    case .to:
        return "Destination"
    }
}
public func runFilter(station: Station, search: String) -> Bool {
    if (search.count >= 1) {
    
        return station.name.lowercased().contains(search.lowercased())
    } else {return true}
}

public struct StationChooser: View {
    var close: (() -> ())
    var choose:  ((Station?) -> ())
    @State var search: String = ""
    let stations: [Station]
    let type: StationType
    @State var filteredStations: [Station] = []
    var spacing:CGFloat = 5
    public init(stations: [Station], type: StationType, close: @escaping (() -> ()), choose: @escaping ((Station?) -> ())) {
        self.close = close
        self.stations = stations
        self.type = type
        self.choose = choose
        self.filteredStations = stations
      
        if #available(iOS 14.0, *) {
                  // modern code
                  spacing = 0
              } else {
                  // Fallback on earlier versions
                  spacing = 5
              }
        
    }
    public var body: some View {
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
                ScrollView {
                    if (self.type == .to && self.search.count < 1) {
                        Button(action: {self.choose(nil)}) {
                            StationCard(station: nil)
                        }.foregroundColor(Color("Text")).padding(.vertical, spacing)
                    }
                    ForEach(stations.filter {runFilter(station: $0, search: self.search)}) {station in
                        Button(action: {self.choose(station)}) {
                            StationCard(station: station)
                        }.foregroundColor(Color("Text")).padding(.vertical, spacing)
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }.padding(.horizontal).edgesIgnoringSafeArea(.bottom)
            Spacer()
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct FromStationChooser_Previews: PreviewProvider {
    static var previews: some View {
        StationChooser(stations: mockData.stations, type: .to, close: {print("close")}, choose: {station in print("choose", station?.abbr)})
    }
}
