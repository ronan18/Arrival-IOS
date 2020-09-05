//
//  HomeScreen.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    HStack {
                        Text("Arrival").font(.largeTitle).foregroundColor(Color.white).fontWeight(.bold)
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Image(systemName: "gear").font(.headline).foregroundColor(.white).padding(5)
                        }
                    }
                }.edgesIgnoringSafeArea(.top).padding().frame(height: geometry.safeAreaInsets.top + 60).background(Color("arrivalBlue"))
                StationChooserBar(leftAction: {print("left")}, centerAction: {print("center")}, rightAction: {print("right")})
                Spacer()
            }
            
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
