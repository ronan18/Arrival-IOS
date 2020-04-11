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
import CoreData
class HostingController: WKHostingController<AnyView> {
        let appData  = AppData()
let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

    override var body: AnyView {
        return AnyView(ContentView().environmentObject(appData).environment(\.managedObjectContext, context))
    }
}
