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
            
            HStack {
                Rectangle()
                    .frame(width: 10.0)
                    .foregroundColor(.red)
                HStack {
                    VStack(alignment: .leading) {
                        Text("direction").font(.caption)
                        Text("Train Name").font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("cars").font(.caption)
                        Text("10").font(.headline)
                    }
                    VStack(alignment: .trailing) {
                        Text("departs").font(.caption)
                        Text("10").font(.headline) + Text(" min").font(.subheadline)
                    }
                }.padding(10.0).padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                
                
            }.cornerRadius(10).background(Color.background).overlay(
                RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
            ).cornerRadius(10.0)
            
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
