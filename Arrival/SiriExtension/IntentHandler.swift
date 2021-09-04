//
//  IntentHandler.swift
//  SiriExtension
//
//  Created by Ronan Furuta on 9/4/21.
//

import Intents
import ArrivalCore
class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return ToStationIntentHandler()
    }
    
}
