//
//  HelpItem.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/26/21.
//

import Foundation
import SwiftUI
import ArrivalCore
/// Link for each individual help item
public struct HelpItem: View {
    public init (_ config: helpScreenData) {
        self.image = config.image
        self.title = config.name
        self.subtitle = config.subtitle
    }
    var image: String
    var title: String
    var subtitle: String
    public var body: some View {
        HStack {
            SquareImage(image: image)
            VStack(alignment:.leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline)
            }.foregroundColor(Color("TextColor")).multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.accentColor)
        }.padding(.vertical, 8)
    }
}
