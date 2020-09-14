//
//  AppStates.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/7/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
public enum AppScreen {
    case loading
    case loadingIndicator
    case home
    case settings
    case onBoarding
}
public enum LocationServicesState {
    case loading
    case ready
    case askForLocation
}
public enum LinkedTripState {
    case loading
    case ready
    case expired
}
