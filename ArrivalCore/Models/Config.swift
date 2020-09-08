//
//  Config.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct OnBoardingScreenConfig {
    let title: String
    let description: String
    var button: String = "CONTINUE"
    
}
struct OnBoardingConfig {
    let welcome: OnBoardingScreenConfig
     let lowDataUsage: OnBoardingScreenConfig
     let smartDataSuggestions: OnBoardingScreenConfig
     let anonymous: OnBoardingScreenConfig
}
