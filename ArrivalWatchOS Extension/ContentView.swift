//
//  ContentView.swift
//  ArrivalWatchOS Extension
//
//  Created by Ronan Furuta on 4/10/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appData:AppData
    var body: some View {
        List {
            Text(self.appData.text)
            Text("Hello, World!")
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppData())
    }
}
