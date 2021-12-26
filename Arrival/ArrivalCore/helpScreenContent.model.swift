//
//  helpScreenContent.model.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 12/26/21.
//

import Foundation

public struct helpScreenData: Identifiable {
    public init(name: String, subtitle: String, image: String, content: [helpScreenContentRow]) {
        self.name = name
        self.subtitle = subtitle
        self.image = image
        self.content = content
    }
    public let id = UUID()
    public let name: String
    public let subtitle: String
    public let image: String
    public let content: [helpScreenContentRow]
}

public struct helpScreenContentRow: Identifiable {
    public init (type: HelpScreenContentType, content: String) {
        self.type = type
        self.content = content
    }
    public let id = UUID()
    public let type: HelpScreenContentType
    public let content: String
}
public enum HelpScreenContentType {
    case text
    case heading
    case image
    case devider
    case spacer
}
