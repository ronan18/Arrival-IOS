//
//  TimeDisplayText.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/21/21.
//

import SwiftUI

struct TimeDisplayText: View {
    let font: Font
    init(font: Font = .headline) {
        self.font = font
    }
    var body: some View {
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
