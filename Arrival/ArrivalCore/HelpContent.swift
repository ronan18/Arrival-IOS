//
//  HelpContent.swift
//  ArrivalCore
//
//  Created by Ronan Furuta on 12/26/21.
//

import Foundation

public struct HelpContent {
   public let featured: helpScreenData
   public let articles: [helpScreenData]
}
public var defaultHelpContent: HelpContent = HelpContent(featured: whatsNew, articles: [basics, roadmap, about])


var whatsNew: helpScreenData = helpScreenData(name: "What's New", subtitle: "Discover new feautres in the latest version of Arrival", image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80", content: [])

var basics = helpScreenData(name: "Basics", subtitle: "Basics of how to use Arrival", image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80", content: [])

var about = helpScreenData(name: "About", subtitle: "About Arrival", image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80", content: [])

var roadmap = helpScreenData(name: "Roadmap", subtitle: "Planned features", image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80", content: [])
