//
//  HelpScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 12/15/21.
//

import SwiftUI
import ArrivalUI
import ArrivalCore
struct HelpScreen: View {
    var close: ()->()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    NavigationLink(destination: HelpScreenText(MockUpData().helpScreen)) {
                        HelpLargeCard(MockUpData().helpScreen).shadow(color: Color("Shadow"), radius: 6, x: 6, y: 6)
                    }.padding(.bottom)
                    
                    NavigationLink(destination: HelpScreenText(MockUpData().helpScreen)) {
                        HelpItem(MockUpData().helpScreen)
                    }
                    NavigationLink(destination: HelpScreenText(MockUpData().helpScreen)) {
                        HelpItem(MockUpData().helpScreen)
                    }
                    NavigationLink(destination: HelpScreenText(MockUpData().helpScreen)) {
                        HelpItem(MockUpData().helpScreen)
                    }
                    
                    
                    Spacer()
                }.padding().navigationTitle("Arrival Tips").navigationBarItems(trailing:Button(action: {
                    self.close()
                }) {
                    Text("Done").foregroundColor(Color("TextColor"))
            })
            }
        }
    }
}

struct HelpScreen_Previews: PreviewProvider {
    static var previews: some View {
        HelpScreen(close: {})
    }
}
