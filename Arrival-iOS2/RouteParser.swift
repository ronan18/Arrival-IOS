//
//  RouteParser.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 4/30/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import Foundation
struct SimpleRoute: Codable {
    var id = UUID()
    var routeShortName: String
     var routeID: String
     var direction: String
     var color: String
    var hexColor: String
    
}

func getRouteData(_ route: String) -> SimpleRoute {
    if let filepath = Bundle.main.path(forResource: "routes", ofType: "csv") {
        do {
            let contents = try String(contentsOfFile: filepath)

          
            let csv = CSwiftV(with: contents)

            let rows = csv.rows
            if let index = rows.firstIndex(where: {$0[0] == route}) {
                let routeRow = rows[index]
                   let routeID = route
                   let routeShortName = routeRow[1]
                   let  hexColor = routeRow[6]
                   let color = routeShortName
                   var direction = "North"
                   if color.suffix(1) == "S" {
                       direction = "South"
                   }
                   print("route parser route", route, routeRow[0], routeRow[2], color)
                   return SimpleRoute(routeShortName: routeShortName, routeID: routeID, direction: direction, color: color, hexColor: hexColor)
            } else {
                fatalError("route not found in data")
            }
   

        } catch {
                fatalError("no routes data")
            // contents could not be loaded
        }
    } else {
        // example.txt not found!
        fatalError("no routes data")
    }
}


