//
//  Loading.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/5/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct Loading: View {
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    Spacer().frame(height: (geometry.size.height / 2)-100)
               
                HStack {
                    Spacer()
                    Image("Splash Screen").resizable().frame(width: 200, height: 200)
                    Spacer()
                }
                Spacer()
                Text("Arrival")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Spacer()
                    Text("v").font(.system(size: 13))
                    Text("\(version)")
                        .font(.footnote)
                    Spacer()
                }
                
                
                .foregroundColor(Color.white)
                
                Spacer()
                }
            }
           
        }.background(LinearGradient(gradient: Gradient(colors: [Color("arrivalBlueBG"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing)).edgesIgnoringSafeArea(.all)
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
