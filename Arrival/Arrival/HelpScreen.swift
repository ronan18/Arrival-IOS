//
//  HelpScreen.swift
//  Arrival
//
//  Created by Ronan Furuta on 12/15/21.
//

import SwiftUI
import ArrivalUI

struct HelpScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination: Text("test")) {
                    HelpLargeCard(title: "What's New").shadow(color: Color("Shadow"), radius: 6, x: 6, y: 6)
                }.padding(.bottom)
                
                HStack {
                    SquareImage(image: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80")
                    VStack(alignment:.leading) {
                        Text("Item").font(.headline)
                        Text("Learn more about this thing").font(.subheadline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }.padding(.vertical)
                
                
                Spacer()
            }.padding().navigationTitle("Arrival Tips").toolbar {
                Button("Done") {
                   
                }
            }
        }
    }
}

struct HelpScreen_Previews: PreviewProvider {
    static var previews: some View {
        HelpScreen()
    }
}
