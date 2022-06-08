//
//  HelpLargeCard.swift
//  ArrivalUI
//
//  Created by Ronan Furuta on 12/15/21.
//

import SwiftUI
import ArrivalCore
public struct HelpLargeCard: View {
    var title: String
    var image: URL
    public init (_ config: helpScreenData) {
        self.title = config.name
        self.image = URL(string: config.image)!
     
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack {
               
                AsyncImage(url: image) {image in
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
      
            HelpLargeCard(MockUpData().helpScreen)
        
        }.padding()
        
    }
}
