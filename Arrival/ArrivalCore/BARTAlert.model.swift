//
//  BARTAlert.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 9/15/21.
//

import Foundation
import CryptoKit
public struct BARTAlert: Identifiable {
    public var id: UUID
    public var station: String
    public var description: String
    public var hash: String
    public init(id: UUID = UUID(), station: String, description: String) {
        self.id = id
        self.station = station
        self.description = description
        let inputString = station + description
        let inputData = Data(inputString.utf8)
        self.hash = SHA256.hash(data: inputData).compactMap { String(format: "%02x", $0) }.joined()
    }
}
