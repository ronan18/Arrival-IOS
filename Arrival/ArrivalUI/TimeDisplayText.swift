//
//  TimeDisplayText.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

public struct TimeDisplayText: View {
    let font: Font
    public init(font: Font = .headline) {
        self.font = font
    }
    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text("10:40").font(font)
            Text("pm").font(.caption)
        }
    }
}

struct TimeDisplayText_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplayText().previewLayout(.sizeThatFits)
    }
}
