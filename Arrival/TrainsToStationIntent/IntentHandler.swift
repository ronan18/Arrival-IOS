//
//  IntentHandler.swift
//  TrainsToStationIntent
//
//  Created by Ronan Furuta on 9/3/21.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return ToStationIntentHandler()
    }
    
}
