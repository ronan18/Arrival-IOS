//
//  NotificationCard.swift
//  Arrival-iOS2
//
//  Created by Ronan Furuta on 9/12/20.
//  Copyright © 2020 Stomp Rocket. All rights reserved.
//

import SwiftUI

struct NotificationCard: View {
    let imageURL: URL?
    let title: String
    let message: String?
    let actionURL: URL?
    let close: (()->())
    var body: some View {
      
        HStack(){
           
       /*
                Image("arrivalLogo").resizable().frame(width: 50, height: 50, alignment: .center).aspectRatio(contentMode: .fill).cornerRadius(10).padding(0)*/
            if (self.imageURL != nil) {
                RemoteImage(url: imageURL!).padding(.leading, -5)
            }
           
            VStack (alignment: .leading) {
                Text(self.title).font(.subheadline).fontWeight(.bold)
                if (self.message != nil) {
                    Text(self.message!).font(.caption)
                }
             
            }.foregroundColor(Color("Text")).padding(.leading, 2)
            
                Spacer()
            Button(action: close) {
                Image(systemName: "xmark.circle.fill").font(.caption)
            }.foregroundColor(Color.gray)
       
        }.padding(10).frame(height: 60.0).cornerRadius(10).background(Color("cardBackground")).overlay(
            RoundedRectangle(cornerRadius: CGFloat(10.0)).stroke(Color(.sRGB, red:170/255, green: 170/255, blue: 170/255, opacity: 0.1), lineWidth:3)
        ).cornerRadius(10.0).onTapGesture {
            print("CARD: CLICK")
            if let url = actionURL {
                UIApplication.shared.open(url)
            }
        }
    
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard(imageURL: URL(string: "https://raw.githubusercontent.com/ronan18/Arrival-IOS/master/Arrival-iOS2/Assets.xcassets/arrivalLogo.imageset/Artboard%2022%20copy%202.png")!, title: "Arrival T-Shirts have arrived!", message: "tap to learn more", actionURL: URL(string:"https://staging.ronanfuruta.com")!, close: {})
    }
}
