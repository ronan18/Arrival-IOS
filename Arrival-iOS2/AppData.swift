//
//  AppData.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 1/15/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
import SwiftUI

class AppData: ObservableObject {
    
    @Published var trains: String = ""
    @Published var passphrase: String = ""
  
    func start() {
print("starting")
    }
    func load() {
        print ("load func ran")
    }
    
  
}
