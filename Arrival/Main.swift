//
//  Main.swift
//  Arrival
//
//  Created by Ronan Furuta on 1/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Main: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            if (self.userData.ready) {
            if self.userData.authorized {
                if userData.trains.count > 0 {
                  ContentView()
                } else {
                    Loading()
                }
                
                
            } else {
                Login()
            }
            } else {
                Loading()
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main().environmentObject(UserData())
    }
}
