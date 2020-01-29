//
//  Test.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/28/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct Test: View {
    init() {
        // 1.
        UINavigationBar.appearance().backgroundColor = UIColor(named: "arrivalBlue")
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
    }
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }.navigationBarTitle("test")
            }.padding(.top, geometry.safeAreaInsets.top - 20)
        }.edgesIgnoringSafeArea(.top)
        
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Test().previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
            Test().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }
    }
}
