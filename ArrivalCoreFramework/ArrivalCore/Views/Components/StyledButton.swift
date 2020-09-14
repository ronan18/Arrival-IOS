//
//  StyledButton.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/6/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

public struct StyledButton: View {
    var action: (() -> ())
    var text: String
    public init(action: @escaping (() -> ()), text: String) {
        self.action = action
        self.text = text
    }
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).fontWeight(.bold)
                Spacer()
            }.padding().foregroundColor(.white).background(Color("arrivalBlue")).cornerRadius(10)
            
        }
    }
}

struct StyledButton_Previews: PreviewProvider {
    static var previews: some View {
        StyledButton(action: {}, text: "Test")
    }
}
