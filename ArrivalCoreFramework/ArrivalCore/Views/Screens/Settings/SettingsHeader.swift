//
//  HomeScreenHeader.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/8/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI
struct SettingsScreenHeader: View {
    var geometry: GeometryProxy
    var navSpace: CGFloat = 60
    var back: (()->())
    init(geometry: GeometryProxy, back: @escaping (()->())) {
        self.geometry = geometry
        if #available(iOS 14.0, *) {
                  // modern code
                  navSpace = 100
              } else {
                  // Fallback on earlier versions
                  navSpace = 60
              }
        self.back = back
    }
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Button(action: back) {
                                   Image(systemName: "chevron.left").font(.headline).foregroundColor(.white).padding(5)
                               
                Text("Settings").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                }
                Spacer()
               
            }
        }.edgesIgnoringSafeArea(.top).padding().frame(height: geometry.safeAreaInsets.top + navSpace).background(LinearGradient(gradient: Gradient(colors: [Color("arrivalBlue"),Color("arrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct SettingsHeader_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader() {geometry in
            SettingsScreenHeader(geometry: geometry, back: {})
        }
 
    }
}
