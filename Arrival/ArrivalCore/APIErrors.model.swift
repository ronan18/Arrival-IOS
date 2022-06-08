//
//  APIErrors.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 8/24/21.
//

import Foundation

public enum APIError: Error {
    case notAuthorized
    case noNetwork
    case requestedPropertyDoesntExist
    case apiError
    case requestError
}
