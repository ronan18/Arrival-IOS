//
//  TrainView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
let sampleData = [1,2,3,4,5]
struct TrainView: View {
    init() {
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        List() {
            TrainComponent(type: "train",  name: "Richmond", cars: 10, departs: 10,unit: "min", color: Color.red)
            
        }
        
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrainView().environment(\.colorScheme, .dark)
            TrainView().environment(\.colorScheme, .light)
        }
    }
}