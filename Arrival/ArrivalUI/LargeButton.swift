//
//  LargeButton.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 8/24/21.
//

import SwiftUI

public struct LargeButton: View {
    let text: String
    let action: ()->()
    let haptic: Bool
    public init (_ text: String, action: @escaping ()->(), haptic: Bool = false) {
        self.text = text
        self.action = action
        self.haptic = haptic
    }
    public var body: some View {
        Button(action: {
            action()
        }) {
            Text(self.text).frame(maxWidth: 400).font(.headline)
                
        }.tint(.accentColor)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton("Test", action: {}, haptic: true)
    }
}
