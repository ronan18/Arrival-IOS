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
    var tosConfig: termsOfServiceConfig
    
}
struct OnBoardingConfig {
    let welcome: OnBoardingScreenConfig
     let lowDataUsage: OnBoardingScreenConfig
     let smartDataSuggestions: OnBoardingScreenConfig
     let anonymous: OnBoardingScreenConfig
    var tosConfig: termsOfServiceConfig
}

struct AlertConfig {
    let content: String
    let link: URL?
}

struct termsOfServiceConfig {
    var tos: URL
    var privacy: URL
}

struct NotificationCardConfig {
    let title: String
    let action: URL?
    let image: URL?
    let message: String?
    let id: String
}

