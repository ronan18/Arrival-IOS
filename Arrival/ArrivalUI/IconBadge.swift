//
//  IconBadge.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 9/15/21.
//

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
           VStack {
               Text(String(badge))
                   .font(.system(size: 6)).fontWeight(.heavy).foregroundColor(.white)
           }.frame(width: 10, height: 10).background(.ultraThinMaterial).cornerRadius(10).position(x: 17, y: 3).opacity(badge >= 1 ? 1 : 0).colorScheme(.light)
          // Circle().foregroundColor(.white)
           
       ).colorScheme(.light)
   }
}

struct IconBadge_Previews: PreviewProvider {
    static var previews: some View {
        IconBadge("exclamationmark.triangle.fill", badge: 1).previewLayout(.sizeThatFits).padding()
    }
}
