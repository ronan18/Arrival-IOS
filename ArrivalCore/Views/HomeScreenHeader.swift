//
//  HomeScreenHeader.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
struct HomeScreenHeader: View {
    var geometry: GeometryProxy
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Arrival").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "gear").font(.headline).foregroundColor(.white).padding(5)
                }
            }
        }.edgesIgnoringSafeArea(.top).padding().frame(height: geometry.safeAreaInsets.top + 60).background(LinearGradient(gradient: Gradient(colors: [Color("arrivalBlueBG"),Color("arrivalBlueBG"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
