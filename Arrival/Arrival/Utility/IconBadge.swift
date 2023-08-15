//
//  IconBadge.swift
//  Arrival
//
//  Created by Ronan Furuta on 8/9/23.
//

import Foundation
import SwiftUI

public struct IconBadge: View {
    let icon: String
    let badge: Int
    public init (_ icon: String, badge: Int) {
        self.icon = icon
        self.badge = badge
    }
   public var body: some View {
       Image(systemName: icon).symbolRenderingMode(.monochrome).overlay(
           ZStack {
               VStack {
                   Text("")
               }.frame(width: 10, height: 10).background(Color.yellow).blur(radius: 1, opaque: false).cornerRadius(10).opacity(0.8).tint(.yellow)
               Text(String(badge))
                   .font(.system(size: 6)).fontWeight(.heavy).foregroundColor(.white)
              
           }.frame(width: 10, height: 10).cornerRadius(10).position(x: 17, y: 3).opacity(badge >= 1 ? 1 : 0).tint(.yellow).colorScheme(.light)
          // Circle().foregroundColor(.white)
           
       ).colorScheme(.light)
   }
}

struct IconBadge_Previews: PreviewProvider {
    static var previews: some View {
        IconBadge("exclamationmark.triangle.fill", badge: 1).previewLayout(.sizeThatFits).padding().colorScheme(.dark)
    }
}
