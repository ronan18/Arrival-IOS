//
//  HelpScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 12/15/21.
//

import SwiftUI
import ArrivalUI

struct HelpScreen: View {
    var close: ()->()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    NavigationLink(destination: Text("test")) {
                        HelpLargeCard(title: "What's New").shadow(color: Color("Shadow"), radius: 6, x: 6, y: 6)
                    }.padding(.bottom)
                    
                    NavigationLink(destination: Text("Text")) {
                        HelpItem(image: "https://images.unsplash.com/photo-1632849513220-ecc7a8c5eb54?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1335&q=80", title: "Basics", subtitle: "Learn the basics of using Arrival")
                    }
                    NavigationLink(destination: Text("Text")) {
                        HelpItem(image: "https://images.unsplash.com/photo-1626443314808-78815aa40621?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1335&q=80", title: "Shortcuts", subtitle: "Small tips and tricks")
                    }
                    NavigationLink(destination: Text("Text")) {
                        HelpItem(image: "https://images.unsplash.com/photo-1617553909815-a38e003fa164?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1335&q=80", title: "Get Support", subtitle: "Get in touch with our suport team")
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

/// Link for each individual help item
struct HelpItem: View {
    var image: String
    var title: String
    var subtitle: String
    var body: some View {
        HStack {
            SquareImage(image: image)
            VStack(alignment:.leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline)
            }.foregroundColor(Color("TextColor"))
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.accentColor)
        }.padding(.vertical, 8)
    }
}
