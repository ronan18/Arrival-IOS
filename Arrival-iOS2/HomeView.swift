//
//  HomeView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import UIKit
struct HomeView: View {
    init() {
        // 1.
        UINavigationBar.appearance().backgroundColor = UIColor(named: "arrivalBlue")
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("from").font(.caption)
                        Text("Station").font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("to").font(.caption)
                        Text("Station").font(.headline)
                    }
                }.padding().foregroundColor(.white).background(Color.black)
                TrainView()
            }.navigationBarTitle("Arrival")
        }.padding(.top, 43.0).edgesIgnoringSafeArea(.top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            HomeView().environment(\.colorScheme, .light)
            HomeView().environment(\.colorScheme, .dark)
        }
    }
}
