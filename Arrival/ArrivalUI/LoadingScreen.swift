//
//  LoadingScreen.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 9/21/21.
//

import SwiftUI

public struct LoadingScreen: View {
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
       var indicator = false
    let versionIndicator: Bool
    public init(indicator: Bool = false, versionInfo: Bool = true) {
           self.indicator = indicator
        self.versionIndicator = versionInfo
       }
       public var body: some View {
           
           VStack {
               GeometryReader { geometry in
                   VStack {
                       Spacer().frame(height: (geometry.size.height / 2)-100)
                  
                   HStack {
                       Spacer()
                       Image("SplashScreen").resizable().frame(width: 200, height: 200)
                       Spacer()
                   }
                   Spacer()
                       if (self.indicator) {
                   
                       
                           ProgressView().tint(.white).controlSize(.large).padding()
                       }
                       if (self.versionIndicator) {
                       Text("Arrival")
                           .font(.headline)
                           .fontWeight(.bold)
                           .foregroundColor(Color.white)
                       HStack(alignment: .lastTextBaseline, spacing: 0) {
                           Spacer()
                           Text("v").font(.system(size: 13))
                           Text("\(self.version)")
                               .font(.footnote)
                           Spacer()
                       }.foregroundColor(Color.white)
                       }
                   
                   Spacer()
                   }
               }
              
           }.background(LinearGradient(gradient: Gradient(colors: [Color("ArrivalBlue"), Color("arrivalBlueBGDark")]), startPoint: .topLeading, endPoint: .bottomTrailing)).edgesIgnoringSafeArea(.all)
       }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen(indicator: true)
    }
}
