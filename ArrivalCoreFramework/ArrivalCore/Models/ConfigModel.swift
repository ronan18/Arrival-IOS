//
//  Config.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
public struct OnBoardingScreenConfig {
    public let title: String
    public let description: String
    public var button: String = "CONTINUE"
    public var tosConfig: termsOfServiceConfig
    public init(title: String, description: String, button: String = "CONTINUE",tosConfig: termsOfServiceConfig) {
        self.title = title
        self.description = description
        self.button = button
        self.tosConfig = tosConfig
    }
    
}
public struct OnBoardingConfig {
    public let welcome: OnBoardingScreenConfig
    public let lowDataUsage: OnBoardingScreenConfig
    public let smartDataSuggestions: OnBoardingScreenConfig
    public let anonymous: OnBoardingScreenConfig
    var tosConfig: termsOfServiceConfig
    public init(welcome: OnBoardingScreenConfig, lowDataUsage: OnBoardingScreenConfig,smartDataSuggestions: OnBoardingScreenConfig, anonymous: OnBoardingScreenConfig,tosConfig: termsOfServiceConfig) {
        self.welcome = welcome
        self.lowDataUsage = lowDataUsage
        self.smartDataSuggestions = smartDataSuggestions
        self.anonymous = anonymous
        self.tosConfig = tosConfig
    }
}

public struct AlertConfig {
    public let content: String
    public let link: URL?
    public init(content: String, link: URL?) {
        self.content = content
        self.link = link
    }
}

public struct termsOfServiceConfig {
    public var tos: URL
    public var privacy: URL
    
    public init(tos: URL,privacy: URL) {
        self.tos = tos
        self.privacy = privacy
    }
}

public struct NotificationCardConfig {
    public let title: String
    public let action: URL?
    public let image: URL?
    public let message: String?
    public let id: String
    public init(title: String, action: URL?,image: URL?,message: String?, id: String) {
        self.title = title
        self.action = action
        self.image = image
        self.message = message
        self.id = id
    }
}

