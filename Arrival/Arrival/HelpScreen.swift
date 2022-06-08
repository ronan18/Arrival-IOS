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
    @ObservedObject var appState: AppState
    var close: ()->()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    NavigationLink(destination: HelpScreenText(appState.helpContent.featured)) {
                        HelpLargeCard(appState.helpContent.featured).shadow(color: Color("Shadow"), radius: 6, x: 6, y: 6)
                    }.padding(.bottom)
                    
                    ForEach(appState.helpContent.articles) { article in
                        NavigationLink(destination: HelpScreenText(article)) {
                            HelpItem(article)
                        }
                    }
                   
                    
                    
                    Spacer()
                }.padding().navigationTitle("Arrival Information").navigationBarItems(trailing:Button(action: {
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
        HelpScreen(appState: AppState(), close: {})
    }
}
