//
//  HostingController.swift
//  ArrivalWatchOS Extension
//
//  Created by Ronan Furuta on 4/10/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {
        let appData  = AppData()
    override var body: AnyView {
        return AnyView(ContentView().environmentObject(appData))
    }
}
