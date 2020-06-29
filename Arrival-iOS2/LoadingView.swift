//
//  LoadingView.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/22/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment:.center) {
            Spacer()
             Image("arrivalLogo").resizable().frame(width: 200.0, height: 200.0).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Spacer()
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
       
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView().environment(\.colorScheme, .light)
            LoadingView().environment(\.colorScheme, .dark)
        }
        
    }
}
