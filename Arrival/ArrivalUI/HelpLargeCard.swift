//
//  HelpLargeCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/15/21.
//

import SwiftUI

public struct HelpLargeCard: View {
    var title: String
    public init (title: String) {
        self.title = title
     
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack {
               
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1638811125056-7a7a5fed3bb6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80")!) {image in
                    image.resizable().aspectRatio( contentMode: .fill).clipped()
                } placeholder: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView().foregroundColor(.white).tint(.white)
                            Spacer()
                        }
                        Spacer()
                       
                    }.background(.gray)
                   
                }.frame(width: geo.size.width, height: 200).clipped()
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Text(title).font(.title2).fontWeight(.bold).foregroundColor(.white).shadow(color: Color("Shadow"), radius: 6, x: 2, y: 2)
                        Spacer()
                    }
                }.padding()
            }.frame(width:  geo.size.width, height: 200).cornerRadius(20)
        }.frame(height: 200)
    }
}

struct HelpLargeCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
      
            HelpLargeCard(title: "Whats New")
        
        }.padding()
        
    }
}
